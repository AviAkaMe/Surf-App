/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();

exports.checkWindSpeed = functions.pubsub.schedule('0 7 * * *')
    .timeZone('Asia/Jerusalem')
    .onRun(async (context) => {
        const locationsRef = db.collection('locations');
        const locationsSnapshot = await locationsRef.get();

        const spotsWithStrongWinds = [];

        const currentTime = new Date();
        const currentTimeInMS = currentTime.getTime();
        const startOfDayMS = new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDate(), 8, 0, 0).getTime();
        const endOfDayMS = new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDate(), 20, 0, 0).getTime();

        const promises = locationsSnapshot.docs.map(async (doc) => {
            const locationData = doc.data();
            const coords = locationData.cords;

            const response = await axios.get(`https://api.openweathermap.org/data/2.5/forecast?lat=${coords.latitude}&lon=${coords.longitude}&appid=f4f0243abc274ba4138270c5b30f7b21`);
            const windSpeedData = response.data.list.filter(item => {
                const itemTime = item.dt * 1000;
                return itemTime >= startOfDayMS && itemTime <= endOfDayMS && item.wind.speed >= 15;
            });

            if (windSpeedData.length > 0) {
                windSpeedData.forEach(item => {
                    if (item.wind.speed >= 15) {
                        const windStartTime = new Date(item.dt * 1000);
                        spotsWithStrongWinds.push({
                            name: locationData.name,
                            windStartTime: windStartTime.toISOString() // Convert to ISO string for logging
                        });
                    }
                });
            }
        });

        await Promise.all(promises);

        console.log('Spots with strong winds:', spotsWithStrongWinds);

        return null;
    });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
