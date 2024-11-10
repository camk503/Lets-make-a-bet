//
//  FirebaseStoreCharts.js
//  MakeABet
//
//  Created by Hannah Sheridan on 11/5/24.
//

/*
 This file fetches API charts data periodically and
 stores it to Firebase database

 This must be done in js

 To do this:
 1. sudo npm install -g firebase-tools
 2. firebase login
 3. firebase init functions

 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

// This is a cloud function in Firebase that runs on a schedule
// functions = Firebase functions library
// pubsub = lets you schedule Cloud Functions in Firebase
// schedule = runs at specified time
exports.storeAPIData = functions.pubsub.schedule("every 24 hours")
    .onRun(async (context) => {
      const url = "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=9e1855dd72c6c6933bae914bd3099bd4&format=json&limit=50";

      try {
        // Get API data
        const response = await axios.get(url);
        const data = response.data.artists.artist;
        const timestamp = new Date().toISOString();

        const artistNames = data.map((artist) => artist.name);

        // Save response to Firebase
        await admin.firestore().collection("charts")
            .doc(timestamp).set({artistNames});

        console.log("Data updated!");
      } catch (error) {
        console.error("Error fetching or saving data: ", error);
      }

      return null;
    });


