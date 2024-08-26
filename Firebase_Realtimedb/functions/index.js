const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {Storage} = require("@google-cloud/storage");
const {v4: uuidv4} = require("uuid"); // 使用 UUID 生成唯一的記錄ID

admin.initializeApp();
const storage = new Storage();

// 保存設備資料到單獨的文件
exports.saveDeviceToCloudStorage = functions.database.ref("/Device/{deviceId}")
    .onWrite(async (change, context) => {
      const deviceId = context.params.deviceId;
      const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
      const originalFile = bucket.file(`Device/Device.jsonl`);

      const deviceData = change.after.val(); // 新的設備資料

      if (deviceData) {
        const changedFields = Object.entries(deviceData).filter(([key, value]) => {
          return !change.before.val() || change.before.val()[key] !== value;
        });

        if (changedFields.length > 0) {
          const structuredData = {
            device_id: deviceId,
            device_name: deviceData.device_name || "",
            model: deviceData.model || "",
            manufacturer: deviceData.manufacturer || "",
            os_version: deviceData.os_version || "",
            serial_number: deviceData.serial_number || "",
            timestamp: Date.now(),
          };

          const recordString = JSON.stringify(structuredData) + "\n";

          try {
            // 檢查原始文件是否存在
            const [originalExists] = await originalFile.exists();

            if (originalExists) {
              // 下載原始文件內容
              const [originalContent] = await originalFile.download();
              // 將新內容追加到原始內容後
              const newContent = originalContent + recordString;

              // 重新上傳合併後的內容
              await originalFile.save(newContent, {
                resumable: false,
                gzip: true,
                contentType: "application/json",
                predefinedAcl: "projectPrivate",
                metadata: {
                  cacheControl: "no-cache",
                },
              });
            } else {
              // 如果原始文件不存在，直接創建新文件
              await originalFile.save(recordString, {
                resumable: false,
                gzip: true,
                contentType: "application/json",
                predefinedAcl: "projectPrivate",
                metadata: {
                  cacheControl: "no-cache",
                },
              });
            }

            console.log(`Structured data for device ${deviceId} saved to Cloud Storage.`);
          } catch (error) {
            console.error(`Error processing device ${deviceId}:`, error);
          }
        }
      } else {
        console.log(`Data for device ${deviceId} was deleted, no changes made to Device.jsonl.`);
      }
    });

// 保存測量資料到單獨的文件
exports.saveMeasurementToCloudStorage = functions.database.ref("/Device/{deviceId}/measurements")
    .onWrite(async (change, context) => {
      const deviceId = context.params.deviceId;
      const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
      const originalFile = bucket.file(`Measurement/Measurement.jsonl`);

      const measurements = change.after.val(); // 新的測量資料

      if (measurements) {
        const newMeasurements = Object.values(measurements).filter((measurement) => {
          return !change.before.val() || !Object.values(change.before.val()).some((prevMeasurement) => {
            return prevMeasurement.timestamp === measurement.timestamp && prevMeasurement.value === measurement.value;
          });
        });

        if (newMeasurements.length > 0) {
          const recordStrings = newMeasurements.map((measurement) => {
            const record = {
              id: uuidv4(),
              device_id: deviceId,
              timestamp: Date.now(),
              measurement: measurement,
            };
            return JSON.stringify(record) + "\n";
          }).join("");

          try {
            // 檢查原始文件是否存在
            const [originalExists] = await originalFile.exists();

            if (originalExists) {
              // 下載原始文件內容
              const [originalContent] = await originalFile.download();
              // 將新內容追加到原始內容後
              const newContent = originalContent + recordStrings;

              // 重新上傳合併後的內容
              await originalFile.save(newContent, {
                resumable: false,
                gzip: true,
                contentType: "application/json",
                predefinedAcl: "projectPrivate",
                metadata: {
                  cacheControl: "no-cache",
                },
              });
            } else {
              // 如果原始文件不存在，直接創建新文件
              await originalFile.save(recordStrings, {
                resumable: false,
                gzip: true,
                contentType: "application/json",
                predefinedAcl: "projectPrivate",
                metadata: {
                  cacheControl: "no-cache",
                },
              });
            }

            console.log(`New measurement data for device ${deviceId} saved to Cloud Storage in Measurement.jsonl.`);
          } catch (error) {
            console.error(`Error processing measurements for device ${deviceId}:`, error);
          }
        }
      } else {
        console.log(`Measurements for device ${deviceId} were deleted, no changes made to Measurement.jsonl.`);
      }
    });

// 保存使用者資料到單獨的文件
exports.saveUserToCloudStorage = functions.database.ref("/User/{userUUID}")
    .onWrite(async (change, context) => {
      const userUUID = context.params.userUUID;
      const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
      const originalFile = bucket.file(`User/User.jsonl`);

      const userData = change.after.val(); // 新的資料

      if (userData) {
        const structuredData = {
          ios_version: userData.ios_version || "",
          iphone_name: userData.iphone_name || "",
          model_number: userData.model_number || "",
          timestamp: userData.timestamp || Date.now(),
          user_uuid: userUUID,
          timezone: userData.timezone || "",
          screen_size: userData.screen_size || "",
          ipv4: userData.ipv4 || "",
          ipv6: userData.ipv6 || "",
          capacity: userData.capacity || "",
          ram: userData.ram || "",
          cpu: userData.cpu || "",
        };

        const recordString = JSON.stringify(structuredData) + "\n";

        try {
          // 檢查原始文件是否存在
          const [originalExists] = await originalFile.exists();

          if (originalExists) {
            // 下載原始文件內容
            const [originalContent] = await originalFile.download();
            const originalLines = originalContent.toString().split("\n").filter(Boolean);
            let found = false;
            let latestRecord = null;

            for (const line of originalLines) {
              const existingRecord = JSON.parse(line);
              if (existingRecord.user_uuid === userUUID) {
                found = true;
                // 找到 timestamp 為最大的紀錄
                if (!latestRecord || existingRecord.timestamp > latestRecord.timestamp) {
                  latestRecord = existingRecord;
                }
              }
            }

            if (found && latestRecord) {
              console.info("Comparing with the latest existing record:", latestRecord);
              const keysToCompare = ["ios_version", "iphone_name", "model_number", "timezone", "screen_size", "ipv4", "ipv6", "capacity", "ram", "cpu"];

              // 檢查是否有不同的內容
              const hasChanges = keysToCompare.some((key) => {
                console.info(`Comparing ${key}: `, structuredData[key], " vs ", latestRecord[key]);
                return String(structuredData[key]) !== String(latestRecord[key]);
              });

              if (!hasChanges) {
                console.info("No changes detected, skipping upload.");
                return; // 如果没有变化，则不继续执行
              }

              if (hasChanges) {
                originalLines.push(recordString);
              }
            } else if (!found) {
              // 如果没有找到相同的 user_uuid，则直接追加新记录
              originalLines.push(recordString);
            }

            // 重新上傳合併後的內容
            const newContent = originalLines.join("\n") + "\n";
            await originalFile.save(newContent, {
              resumable: false,
              gzip: true,
              contentType: "application/json",
              predefinedAcl: "projectPrivate",
              metadata: {
                cacheControl: "no-cache",
              },
            });
          } else {
            // 如果原始文件不存在，直接創建新文件
            await originalFile.save(recordString, {
              resumable: false,
              gzip: true,
              contentType: "application/json",
              predefinedAcl: "projectPrivate",
              metadata: {
                cacheControl: "no-cache",
              },
            });
          }

          console.info(`Structured data for user ${userUUID} saved to Cloud Storage.`);
        } catch (error) {
          console.error(`Error processing user data for ${userUUID}:`, error);
        }
      } else {
        console.info(`Data for user ${userUUID} was deleted, no changes made to User.jsonl.`);
      }
    });


// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// const {Storage} = require("@google-cloud/storage");
// const {v4: uuidv4} = require("uuid"); // 使用 UUID 生成唯一的記錄ID

// admin.initializeApp();
// const storage = new Storage();

// // 保存設備資料到單獨的文件
// exports.saveDeviceToCloudStorage = functions.database.ref("/Device/{deviceId}")
//     .onWrite(async (change, context) => {
//       const deviceId = context.params.deviceId;
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
//       const file = bucket.file(`Device/Device.jsonl`); // 所有設備資料寫入同一個文件

//       const deviceData = change.after.val(); // 新的設備資料
//       const previousDeviceData = change.before.val(); // 之前的設備資料

//       if (deviceData) {
//         // 檢查哪些欄位發生了變化
//         const changedFields = Object.entries(deviceData).filter(([key, value]) => {
//           return !previousDeviceData || previousDeviceData[key] !== value;
//         });

//         if (changedFields.length > 0) {
//           // 構建一個完整的 JSON 對象
//           const structuredData = {
//             device_id: deviceId,
//             device_name: deviceData.device_name || "",
//             model: deviceData.model || "",
//             manufacturer: deviceData.manufacturer || "",
//             os_version: deviceData.os_version || "",
//             serial_number: deviceData.serial_number || "",
//             timestamp: Date.now(),
//           };

//           const recordString = JSON.stringify(structuredData) + "\n";

//           // 檢查文件是否存在，並追加新的資料
//           const [exists] = await file.exists();
//           if (exists) {
//             const [existingContent] = await file.download();
//             const newContent = existingContent + recordString;
//             await file.save(newContent); // 保存更新後的內容
//           } else {
//             // 如果文件不存在，直接創建並保存
//             await file.save(recordString);
//           }

//           console.log(`Structured data for device ${deviceId} saved to Cloud Storage.`);
//         }
//       } else {
//         // 如果設備資料被刪除，不執行任何操作或進行其他處理
//         console.log(`Data for device ${deviceId} was deleted, no changes made to Device.jsonl.`);
//       }
//     });

// // 保存測量資料到單獨的文件
// exports.saveMeasurementToCloudStorage = functions.database.ref("/Device/{deviceId}/measurements")
//     .onWrite(async (change, context) => {
//       const deviceId = context.params.deviceId;
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
//       const file = bucket.file(`Measurement/Measurement.jsonl`); // 所有測量資料寫入同一個文件

//       const measurements = change.after.val(); // 新的測量資料
//       const previousMeasurements = change.before.val(); // 之前的測量資料

//       if (measurements) {
//         // 找出新增的測量資料（只在 after 中存在的資料）
//         const newMeasurements = Object.values(measurements).filter((measurement) => {
//           return !previousMeasurements || !Object.values(previousMeasurements).some((prevMeasurement) => {
//             return prevMeasurement.timestamp === measurement.timestamp && prevMeasurement.value === measurement.value;
//           });
//         });

//         if (newMeasurements.length > 0) {
//           const recordStrings = newMeasurements.map((measurement) => {
//             const record = {
//               id: uuidv4(),
//               device_id: deviceId,
//               timestamp: Date.now(),
//               measurement: measurement,
//             };
//             return JSON.stringify(record) + "\n";
//           }).join("");

//           // 檢查文件是否存在，並追加新的資料
//           const [exists] = await file.exists();
//           if (exists) {
//             const [existingContent] = await file.download();
//             const newContent = existingContent + recordStrings;
//             await file.save(newContent); // 保存更新後的內容
//           } else {
//             // 如果文件不存在，直接創建並保存
//             await file.save(recordStrings);
//           }

//           console.log(`New measurement data for device ${deviceId} saved to Cloud Storage in Measurement.jsonl.`);
//         }
//       }
//     });

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// const {Storage} = require("@google-cloud/storage");
// const {v4: uuidv4} = require("uuid"); // 使用 UUID 生成唯一的记录ID

// admin.initializeApp();
// const storage = new Storage();

// exports.saveToCloudStorage = functions.database.ref("/Device/{deviceId}/measurements")
//     .onWrite(async (change, context) => {
//       const deviceId = context.params.deviceId;
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com");
//       const file = bucket.file(`Device/${deviceId}.jsonl`);

//       const measurements = change.after.val(); // 新的测量数据
//       const previousMeasurements = change.before.val(); // 之前的测量数据

//       if (measurements) {
//         // 找出新增的测量数据（只在 after 中存在的数据）
//         const newMeasurements = Object.values(measurements).filter((measurement) => {
//           return !previousMeasurements || !Object.values(previousMeasurements).some((prevMeasurement) => {
//             return prevMeasurement.timestamp === measurement.timestamp && prevMeasurement.value === measurement.value;
//           });
//         });

//         if (newMeasurements.length > 0) {
//           const recordStrings = newMeasurements.map((measurement) => {
//             const record = {id: uuidv4(), timestamp: Date.now(), data: measurement};
//             return JSON.stringify(record) + "\n";
//           }).join("");

//           // 检查文件是否存在，并追加新的数据
//           const [exists] = await file.exists();
//           if (exists) {
//             const [existingContent] = await file.download();
//             const newContent = existingContent + recordStrings;
//             await file.save(newContent); // 保存更新后的内容
//           } else {
//             // 如果文件不存在，直接创建并保存
//             await file.save(recordStrings);
//           }

//           console.log(`New measurement data for device ${deviceId} saved to Cloud Storage.`);
//         }
//       }
//     });


// exports.saveToCloudStorage = functions.database.ref("/Device/{deviceId}")
//     .onWrite(async (change, context) => {
//       const deviceId = context.params.deviceId;
//       const deviceData = change.after.val();
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name
//       const file = bucket.file(`Device/${deviceId}.jsonl`);

//       if (deviceData) {
//         // 构建新的记录
//         const record = {id: uuidv4(), timestamp: Date.now(), data: deviceData};
//         const recordString = JSON.stringify(record) + "\n";

//         // 检查文件是否存在
//         const [exists] = await file.exists();
//         if (exists) {
//           // 如果文件存在，先读取现有内容，然后追加新内容
//           const [existingContent] = await file.download();
//           const newContent = existingContent + recordString;
//           await file.save(newContent); // 保存更新后的内容
//         } else {
//           // 如果文件不存在，直接创建并保存新内容
//           await file.save(recordString);
//         }
//         console.log(`Data for device ${deviceId} saved to Cloud Storage.`);
//       } else {
//         // 数据已被删除
//         await file.delete();
//         console.log(`Data for device ${deviceId} deleted from Cloud Storage.`);
//       }
//     });

// // 保存使用者資料到單獨的文件
// exports.saveUserToCloudStorage = functions.database.ref("/User/{userUUID}")
//     .onWrite(async (change, context) => {
//       const userUUID = context.params.userUUID;
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // 替換為 Cloud Storage 存儲桶名稱
//       const file = bucket.file(`User/User.jsonl`); // 所有使用者資料寫入同一個文件

//       const userData = change.after.val(); // 新的資料
//       const previousUserData = change.before.val(); // 之前的資料

//       if (userData) {
//         // 找出新增或更新的資料（只在 after 中存在的資料，或者與 before 資料不同）
//         const newUserData = Object.entries(userData).filter(([key, value]) => {
//           return !previousUserData || !Object.entries(previousUserData).some(([prevKey, prevValue]) => {
//             return prevKey === key && prevValue === value;
//           });
//         });

//         if (newUserData.length > 0) {
//           // 構建一個完整的 JSON 對象
//           const structuredData = {
//             bluetooth: userData.bluetooth || "",
//             eid: userData.eid || "",
//             ios_version: userData.ios_version || "",
//             iphone_name: userData.iphone_name || "",
//             model_number: userData.model_number || "",
//             seid: userData.seid || "",
//             serial_number: userData.serial_number || "",
//             timestamp: userData.timestamp || Date.now(),
//             user_uuid: userUUID,
//             wifi_address: userData.wifi_address || "",
//           };

//           const recordString = JSON.stringify(structuredData) + "\n";

//           // 檢查文件是否存在，並追加新的資料
//           const [exists] = await file.exists();
//           if (exists) {
//             const [existingContent] = await file.download();
//             const newContent = existingContent + recordString;
//             await file.save(newContent); // 保存更新後的內容
//           } else {
//             // 如果文件不存在，直接創建並保存
//             await file.save(recordString);
//           }

//           console.log(`Structured data for user ${userUUID} saved to Cloud Storage.`);
//         }
//       } else {
//         // 如果使用者資料被刪除，不執行任何操作或進行其他處理
//         console.log(`Data for user ${userUUID} was deleted, no changes made to User.jsonl.`);
//       }
//     });

// exports.saveUserToCloudStorage = functions.database.ref("/User/{userUUID}")
//     .onWrite(async (change, context) => {
//       const userUUID = context.params.userUUID;
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name
//       const file = bucket.file(`User/User.jsonl`); // 将所有用户数据写入同一个文件

//       const userData = change.after.val(); // 新的数据
//       const previousUserData = change.before.val(); // 之前的数据

//       if (userData) {
//         // 找出新增的数据（只在 after 中存在的数据）
//         const newUserData = Object.values(userData).filter((data) => {
//           return !previousUserData || !Object.values(previousUserData).some((prevData) => {
//             return prevData.timestamp === data.timestamp && prevData.value === data.value;
//           });
//         });

//         if (newUserData.length > 0) {
//           const recordStrings = newUserData.map((data) => {
//             const record = {id: uuidv4(), userUUID: userUUID, timestamp: Date.now(), data: data};
//             return JSON.stringify(record) + "\n";
//           }).join("");

//           // 检查文件是否存在，并追加新的数据
//           const [exists] = await file.exists();
//           if (exists) {
//             const [existingContent] = await file.download();
//             const newContent = existingContent + recordStrings;
//             await file.save(newContent); // 保存更新后的内容
//           } else {
//             // 如果文件不存在，直接创建并保存
//             await file.save(recordStrings);
//           }

//           console.log(`New data for user ${userUUID} saved to Cloud Storage in User.jsonl.`);
//         }
//       } else {
//         // Data has been deleted
//         await file.delete();
//         console.log(`Data for user ${userUUID} was deleted, no changes made to User.jsonl.`);
//         // 如果需要处理删除的逻辑，可以在此处添加
//       }
//     });

// exports.saveUserToCloudStorage = functions.database.ref("/User/{userUUID}")
//     .onWrite(async (change, context) => {
//       const userUUID = context.params.userUUID;
//       const userData = change.after.val();
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name
//       const file = bucket.file(`User/${userUUID}.jsonl`);

//       if (userData) {
//         // Data has been updated or added
//         const record = {id: uuidv4(), timestamp: Date.now(), data: userData};
//         const recordString = JSON.stringify(record) + "\n";

//         // Check if the file exists
//         const [exists] = await file.exists();
//         if (exists) {
//           // If file exists, download existing content and append the new record
//           const [existingContent] = await file.download();
//           const newContent = existingContent + recordString;
//           await file.save(newContent); // Save the updated content
//         } else {
//           // If file doesn't exist, save the new record as the content
//           await file.save(recordString);
//         }
//         console.log(`Data for user ${userUUID} saved to Cloud Storage.`);
//       } else {
//         // Data has been deleted
//         await file.delete();
//         console.log(`Data for user ${userUUID} deleted from Cloud Storage.`);
//       }
//     });

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// const {Storage} = require("@google-cloud/storage");

// admin.initializeApp();
// const storage = new Storage();

// exports.saveToCloudStorage = functions.database.ref("/Device/{deviceId}")
//     .onWrite(async (change, context) => {
//       const deviceId = context.params.deviceId;
//       const deviceData = change.after.val();
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name

//       if (deviceData) {
//         // Data has been updated or added
//         const file = bucket.file(`Device/${deviceId}.json`);
//         await file.save(JSON.stringify(deviceData));
//         console.log(
//             `Data for device ${deviceId} saved to Cloud Storage.`,
//         );
//       } else {
//         // Data has been deleted
//         const file = bucket.file(`Device/${deviceId}.json`);
//         await file.delete();
//         console.log(
//             `Data for device ${deviceId} deleted from Cloud Storage.`,
//         );
//       }
//     });

// exports.saveUserToCloudStorage = functions.database.ref("/User/{userUUID}")
//     .onWrite(async (change, context) => {
//       const userUUID = context.params.userUUID;
//       const userData = change.after.val();
//       const bucket = storage.bucket("firestore-ios-codelab-6b5d5.appspot.com"); // Replace with your Cloud Storage bucket name

//       if (userData) {
//         // Data has been updated or added
//         const file = bucket.file(`User/${userUUID}.json`);
//         await file.save(JSON.stringify(userData));
//         console.log(`Data for user ${userUUID} saved to Cloud Storage.`);
//       } else {
//         // Data has been deleted
//         const file = bucket.file(`User/${userUUID}.json`);
//         await file.delete();
//         console.log(`Data for user ${userUUID} deleted from Cloud Storage.`);
//       }
//     });
