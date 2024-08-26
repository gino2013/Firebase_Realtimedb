const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {Storage} = require("@google-cloud/storage");

admin.initializeApp();
const storage = new Storage();

exports.saveToCloudStorage = functions.database.ref("/medicalDevices/{deviceId}")
    .onWrite(async (change, context) => {
      const deviceId = context.params.deviceId;
      const deviceData = change.after.val();
      const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name

      if (deviceData) {
        // Data has been updated or added
        const file = bucket.file(`medicalDevices/${deviceId}.json`);
        await file.save(JSON.stringify(deviceData));
        console.log(
            `Data for device ${deviceId} saved to Cloud Storage.`,
        );
      } else {
        // Data has been deleted
        const file = bucket.file(`medicalDevices/${deviceId}.json`);
        await file.delete();
        console.log(
            `Data for device ${deviceId} deleted from Cloud Storage.`,
        );
      }
    });
