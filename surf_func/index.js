const admin = require('firebase-admin');
const functions = require('firebase-functions');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

exports.findSpotsWind = functions.https.onRequest(async (request, response) => {

  try {
    const value = request.query.value || '0:30';
    const latitude = request.query.latitude || 'unknown';
    const longitude = request.query.longitude || 'unknown';

    const strongWindsResponse = await axios.get('https://us-central1-b-surf.cloudfunctions.net/getStrongWinds');
    const spotsWithStrongWindsArray = strongWindsResponse.data.spotsWithStrongWinds;

    const lines = [];

    spotsWithStrongWindsArray.forEach(spot => {
      const location = spot.name;

      const windStartTime = new Date(spot.windStartTime);
      windStartTime.setHours(windStartTime.getHours() + 3); // Adding 3 hours
      const formattedWindStartTime = windStartTime.toISOString().substr(11, 5);

      lines.push(`Wind starts today at ${location} at ${formattedWindStartTime}`);
    });

    response.send(JSON.stringify(lines));
  } catch (error) {
    console.error('Error:', error);
    response.status(500).send('An error occurred');
  }
});

exports.getStrongWinds = functions.https.onRequest(async (request, response) => {
    try {
        const { date } = request.query;
        const locationsRef = db.collection('locations');
        const locationsSnapshot = await locationsRef.get();

        const spotsWithStrongWinds = {};

        const promises = locationsSnapshot.docs.map(async (doc) => {
            const locationData = doc.data();
            const coords = locationData.cords;

            const latitude = parseFloat(coords.latitude);
            const longitude = parseFloat(coords.longitude);

            const currentDate = new Date();
            const formattedDate = date || currentDate.toISOString().substr(0, 10);

            const response = await axios.get(`https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&hourly=windspeed_10m&current_weather=true&windspeed_unit=kn&start_date=${formattedDate}&end_date=${formattedDate}`);

            const hourlyData = response.data.hourly;

            let relevantHourlyData;
            let relevantWindspeedData;

            if (formattedDate === currentDate.toISOString().substr(0, 10)) {
                const currentHour = currentDate.getUTCHours();
                const startIndex = Math.max(currentHour, 5);
                const endIndex = Math.max(16 - startIndex, 0);
                relevantHourlyData = hourlyData.time.slice(startIndex, startIndex + endIndex);
                relevantWindspeedData = hourlyData.windspeed_10m.slice(startIndex, startIndex + endIndex);
            } else {
                relevantHourlyData = hourlyData.time.slice(5, 5 + 11);  // 5:00-15:00utc
                relevantWindspeedData = hourlyData.windspeed_10m.slice(5, 5 + 11);
            }

            const earliestIndex = relevantWindspeedData.findIndex(speed => speed >= 14); // knots

            if (earliestIndex !== -1) {
                const earliestTime = new Date(relevantHourlyData[earliestIndex]);
                if (!spotsWithStrongWinds[locationData.name] || earliestTime < spotsWithStrongWinds[locationData.name]) {
                    spotsWithStrongWinds[locationData.name] = earliestTime;
                }
            }
        });

        await Promise.all(promises);

        const spotsWithStrongWindsArray = Object.keys(spotsWithStrongWinds).map(name => ({
            name,
            windStartTime: spotsWithStrongWinds[name].toISOString()
        }));

        console.log('Spots with strong winds:', spotsWithStrongWindsArray);

        response.status(200).json({ spotsWithStrongWinds: spotsWithStrongWindsArray });
    } catch (error) {
        console.error('Error:', error);
        response.status(500).send('An error occurred');
    }
});

exports.scheduledAlerts = functions.pubsub.schedule('30 7 * * *') // have to be before 8am
    .timeZone('Asia/Jerusalem') // Israel timezone
    .onRun(async (context) => {
        try {
            const strongWindsResponse = await axios.get('https://us-central1-b-surf.cloudfunctions.net/getStrongWinds');

            const spotsWithStrongWindsArray = strongWindsResponse.data.spotsWithStrongWinds;

            const usersRef = db.collection('users');
            const usersSnapshot = await usersRef.get();

            const promises = usersSnapshot.docs.map(async (doc) => {
                const userData = doc.data();
                if (userData.favoriteSpot && spotsWithStrongWindsArray.some(spot => spot.name === userData.favoriteSpot)) {
                    const userDeviceToken = userData.deviceToken; // Assuming you have a device token field
                    if (userDeviceToken) {
                        const windStartTime = spotsWithStrongWindsArray.find(spot => spot.name === userData.favoriteSpot).windStartTime;

                        const modifiedWindStartTime = new Date(windStartTime);
                        modifiedWindStartTime.setHours(modifiedWindStartTime.getHours() + 3);
                        const formattedWindStartTime = modifiedWindStartTime.toISOString().substr(11, 5);

                        const message = {
                            token: userDeviceToken,
                            notification: {
                                title: 'KiteSurf Winds Alert',
                                body: `Wake up! winds at your favorite spot are expected at ${formattedWindStartTime}.`
                            }
                        };

                        await fcm.send(message);
                    }
                }
            });

            await Promise.all(promises);

            return null;
        } catch (error) {
            console.error('Error:', error);
            return null;
        }
    });
