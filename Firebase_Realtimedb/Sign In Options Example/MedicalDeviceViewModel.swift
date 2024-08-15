import FirebaseDatabase
import SwiftUI
import Foundation

class MedicalDeviceViewModel: ObservableObject {
    @Published var medicalDevices = [MedicalDevice]()
    var currentUserUUID: String?  // 添加这个属性
    private var dbRef: DatabaseReference

    init() {
         self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
         self.currentUserUUID = "some-default-uuid"  // 可以根据需求设置初始值
         fetchMedicalDevices()
     }

    func fetchMedicalDevices() {
          guard let userUUID = currentUserUUID else { return }
          dbRef.child("Device").observe(.value) { snapshot in
              var devices = [MedicalDevice]()
              for child in snapshot.children {
                  if let childSnapshot = child as? DataSnapshot,
                     let dict = childSnapshot.value as? [String: Any] {
                      let device = MedicalDevice(from: dict, id: childSnapshot.key)
                      devices.append(device)
                  }
              }
              self.medicalDevices = devices
          }
      }

    func updateMedicalDevice(_ device: MedicalDevice) {
        guard let id = device.id else { return }
        dbRef.child("Device").child(id).setValue(device.toDictionary())
    }

    func addMedicalDevice(_ device: MedicalDevice) {
        let newDeviceRef = dbRef.child("Device").childByAutoId()
        newDeviceRef.setValue(device.toDictionary())
    }

    func deleteMedicalDevice(_ device: MedicalDevice) {
        guard let id = device.id else { return }
        dbRef.child("Device").child(id).removeValue()
    }
}


//import FirebaseDatabase
//import SwiftUI
//import UIKit
//import CoreData
//
//// 負責管理醫療設備資料的ViewModel
//class MedicalDeviceViewModel: ObservableObject {
//    @Published var medicalDevices = [MedicalDevice]() // 儲存所有醫療設備的陣列
//    private var dbRef: DatabaseReference // Firebase Realtime Database的參考
//    var currentUserUUID: String? // 當前使用者的 UUID
//
//    // 初始化，設置資料庫參考並獲取醫療設備資料
//    init() {
//        self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
//        fetchMedicalDevices()
//    }
//
//    // 從Firebase中獲取醫療設備資料
//    func fetchMedicalDevices() {
//        guard let userUUID = currentUserUUID else { return }
//
//        dbRef.child("Device").observe(.value) { snapshot in
//            var devices = [MedicalDevice]()
//            // 遍歷快照中的每個子項
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                   let dict = childSnapshot.value as? [String: Any],
//                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
//                   var device = try? JSONDecoder().decode(MedicalDevice.self, from: jsonData) {
//                    device.id = childSnapshot.key // 設置設備的ID
//                    devices.append(device) // 將設備添加到陣列中
//                }
//            }
//            self.medicalDevices = devices.filter { $0.measurements.contains(where: { $0.user_uuid == userUUID }) } // 過濾與當前用戶關聯的設備
//        }
//    }
//
//    // 更新Firebase中的醫療設備資料
//    func updateMedicalDevice(_ device: MedicalDevice) {
//        guard let id = device.id else { return }
//        // 將設備資料寫回Firebase
//        dbRef.child("Device").child(id).setValue(device.toDictionary())
//    }
//
//    // 新增醫療設備資料
//    func addMedicalDevice(_ device: MedicalDevice) {
//        let newDeviceRef = dbRef.child("Device").childByAutoId()
//        newDeviceRef.setValue(device.toDictionary())
//    }
//
//    // 刪除Firebase中的醫療設備資料
//    func deleteMedicalDevice(_ device: MedicalDevice) {
//        guard let id = device.id else { return }
//        dbRef.child("medicalDevices").child(id).removeValue()
//    }
//}
