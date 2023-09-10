const admin = require('firebase-admin');
const functions = require('firebase-functions');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

//////////////////////////////////////////////////////////////////////////

exports.calculateTravelTimes = functions.https.onRequest(async (req, res) => {
  try {
    // Get user's origin coordinates from the request
    const { lat, lng } = req.query;
    const userCoords = `${lat},${lng}`;

    // Fetch destination locations from Firestore
    const locationsSnapshot = await admin.firestore().collection('locations').get();
    const destinationData = locationsSnapshot.docs.map(doc => {
      const data = doc.data();
      const geopoint = data.cords;
      return {
        name: data.name, // Retrieve the name
        coords: `${geopoint.latitude},${geopoint.longitude}`
      };
    });

    console.log('Original Destination Locations:', JSON.stringify(destinationData));

    // Modify the user's location to have a name and coords
    const userLocation = {
      name: 'currentUser', // You can choose any name you prefer, e.g., 'currentUser'
      coords: userCoords,
    };

    // Add the user's location to the beginning of the locations array
    const locations = [userLocation, ...destinationData];

    console.log('Updated Destination Locations:', JSON.stringify(locations));

    // Prepare API request for MapQuest Distance Matrix API
    const apiKey = 'meUpZF1IJC1xerOyaagheDBFWvK5uOk1';
    const apiUrl = 'https://www.mapquestapi.com/directions/v2/routematrix';

    const requestBody = {
      locations: locations.map(item => item.coords), // Use the modified locations array
      options: {
        allToAll: false, // Set to false to calculate travel times from one source to all destinations
        unit: 'm', // You can specify the unit you want here (meters)
      },
      key: apiKey
    };

    // Make API request to MapQuest Distance Matrix API
    const response = await axios.post(apiUrl, requestBody);

    if (response.data.info.statuscode === 0) {
      const travelTimes = response.data.time.map((duration, index) => {
        const minutes = Math.round(duration / 60); // Convert duration to rounded minutes
        return {
          duration: duration,
          name: locations[index].name, // Use the modified locations array
          durationMinutes: minutes
        };
      });

      // Send the extracted travel times with names and duration in minutes
      res.json({ travelTimes });
    } else {
      console.error('MapQuest API Error:', response.data.info.statuscode);
      res.status(500).json({ error: 'An error occurred while fetching data from the API' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred' });
  }
});
///////////////////////////////////////////////////////////////////////////

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

        const todayLines = await getStrongWindsData(formattedToday, 'today', value, latitude, longitude);
        const tomorrowLines = await getStrongWindsData(formattedTomorrow, 'tomorrow', value, latitude, longitude);
        const dayAfterTomorrowLines = await getStrongWindsData(formattedDayAfterTomorrow, 'the day after', value, latitude, longitude);

        const allLines = [...todayLines, ...tomorrowLines, ...dayAfterTomorrowLines];

        response.send(JSON.stringify(allLines));
    } catch (error) {
        console.error('Error:', error);
        response.status(500).send('An error occurred');
    }
});

async function getStrongWindsData(date, dayLabel, value, latitude, longitude) {
    const strongWindsResponse = await axios.get(`https://us-central1-b-surf.cloudfunctions.net/getStrongWinds?date=${date}&value=${value}&latitude=${latitude}&longitude=${longitude}`);
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

///////////////////////////////////////////////////////////////////////////

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

            const earliestIndex = relevantWindspeedData.findIndex(speed => speed >= 5); // speed in knots

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

        const finalResponse = {
            spotsWithStrongWinds: spotsWithStrongWindsArray,
        };

        response.status(200).json(finalResponse);
    } catch (error) {
        console.error('Error:', error);
        response.status(500).send('An error occurred');
    }
});

///////////////////////////////////////////////////////////////////////////

//send msg if wind at fav spot
exports.scheduledAlerts = functions.pubsub.schedule('15 13 * * *').timeZone('Asia/Jerusalem')
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
