const admin = require('firebase-admin');
const functions = require('firebase-functions');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

exports.calculateTravelTimes = functions.https.onRequest(async (req, res) => {
    try {
        // Get user's origin coordinates from the request
        const { lat, lng } = req.query;
        const userCoords = `${lat},${lng}`;

        // Fetch destination locations from Firestore
        const locationsSnapshot = await admin.firestore().collection('locations').get();
        const destinationCoords = locationsSnapshot.docs.map(doc => {
            const geopoint = doc.data().cords;
            return `${geopoint.latitude},${geopoint.longitude}`;
        });

        // Prepare API request
        const apiKey = 'AIzaSyC-Jb-ngFC5Pl-QRXJGAblhKVIQrSt0uRk';
        const apiUrl = `https://maps.googleapis.com/maps/api/distancematrix/json`;
        const params = {
            origins: userCoords,
            destinations: destinationCoords.join('|'),
            units: 'imperial',
            key: apiKey
        };

        // Construct the URL for debugging purposes
        const constructedUrl = `${apiUrl}?${new URLSearchParams(params).toString()}`;

        // Make API request to Google Distance Matrix API
        const response = await axios.get(apiUrl, { params });

        if (response.data.status === 'OK') {
            const travelTimes = response.data.rows[0].elements.map(element => {
                if (element.status === 'OK') {
                    return {
                        duration: element.duration.text,
                        status: element.status
                    };
                } else {
                    return {
                        duration: 'N/A',
                        status: element.status
                    };
                }
            });

            // Send the extracted travel times and constructed URL
            res.json({ travelTimes, constructedUrl });
        } else {
            console.error('Google API Error:', response.data.status);
            res.status(500).json({ error: 'An error occurred while fetching data from the API' });
        }
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'An error occurred' });
    }
});

//exports.findSpotsWind = functions.https.onRequest(async (request, response) => {
//
//  try {
//    const value = request.query.value || '0:30';
//    const latitude = request.query.latitude || 'unknown';
//    const longitude = request.query.longitude || 'unknown';
//
//    const strongWindsResponse = await axios.get('https://us-central1-b-surf.cloudfunctions.net/getStrongWinds');
//    const spotsWithStrongWindsArray = strongWindsResponse.data.spotsWithStrongWinds;
//
//    const lines = [];
//
//    spotsWithStrongWindsArray.forEach(spot => {
//      const location = spot.name;
//
//      const windStartTime = new Date(spot.windStartTime);
//      windStartTime.setHours(windStartTime.getHours() + 3); // Adding 3 hours
//      const formattedWindStartTime = windStartTime.toISOString().substr(11, 5);
//
//      lines.push(`Wind starts today at ${location} at ${formattedWindStartTime}`);
//    });
//
//    response.send(JSON.stringify(lines));
//  } catch (error) {
//    console.error('Error:', error);
//    response.status(500).send('An error occurred');
//  }
//});

exports.findSpotsWind = functions.https.onRequest(async (request, response) => {
  try {

    const value = request.query.value || null;
    const latitude = request.query.latitude || 'unknown';
    const longitude = request.query.longitude || 'unknown';

    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const dayAfterTomorrow = new Date(tomorrow);
    dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 1);

    const formattedToday = today.toISOString().substr(0, 10);
    const formattedTomorrow = tomorrow.toISOString().substr(0, 10);
    const formattedDayAfterTomorrow = dayAfterTomorrow.toISOString().substr(0, 10);

    const todayLines = await getStrongWindsData(formattedToday, 'today');
    const tomorrowLines = await getStrongWindsData(formattedTomorrow, 'tomorrow');
    const dayAfterTomorrowLines = await getStrongWindsData(formattedDayAfterTomorrow, 'the day after');

    const allLines = [...todayLines, ...tomorrowLines, ...dayAfterTomorrowLines];

    response.send(JSON.stringify(allLines));
  } catch (error) {
    console.error('Error:', error);
    response.status(500).send('An error occurred');
  }
});

async function getStrongWindsData(date, dayLabel) {
  const strongWindsResponse = await axios.get(`https://us-central1-b-surf.cloudfunctions.net/getStrongWinds?date=${date}`);
  const spotsWithStrongWindsArray = strongWindsResponse.data.spotsWithStrongWinds;

  const lines = [];

  spotsWithStrongWindsArray.forEach(spot => {
    const location = spot.name;
    const windStartTime = new Date(spot.windStartTime);

    // Adjust the wind start time based on the dayLabel
    if (dayLabel === 'tomorrow') {
      windStartTime.setDate(windStartTime.getDate() + 1);
    } else if (dayLabel === 'the day after tomorrow') {
      windStartTime.setDate(windStartTime.getDate() + 2);
    }

    windStartTime.setHours(windStartTime.getHours() + 3);
    const formattedWindStartTime = windStartTime.toISOString().substr(11, 5);

    lines.push(`Wind ${dayLabel} at ${location} at ${formattedWindStartTime}`);
  });

  return lines;
}

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

            const earliestIndex = relevantWindspeedData.findIndex(speed => speed >= 11); // knots

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
    //.timeZone('Asia/Jerusalem') // Israel timezone
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
