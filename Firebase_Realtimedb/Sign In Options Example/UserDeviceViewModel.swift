import FirebaseDatabase
import SwiftUI
import Foundation
import CoreData

class UserDeviceViewModel: ObservableObject {
    @Published var userDevice: UserDevice?
    private var dbRef: DatabaseReference
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }

    func fetchUserDevice(userUUID: String) {
        dbRef.child("User").child(userUUID).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                // 从 Firebase 数据创建 UserDevice 对象
                let fetchedUserDevice = UserDevice(
                    bluetooth: dict["bluetooth"] as? String ?? "",
                    eid: dict["eid"] as? String ?? "",
                    ios_version: dict["ios_version"] as? String ?? "",
                    iphone_name: dict["iphone_name"] as? String ?? "",
                    model_number: dict["model_number"] as? String ?? "",
                    seid: dict["seid"] as? String ?? "",
                    serial_number: dict["serial_number"] as? String ?? "",
                    timestamp: dict["timestamp"] as? Double ?? Date().timeIntervalSince1970,
                    user_uuid: dict["user_uuid"] as? String ?? UUID().uuidString,
                    wifi_address: dict["wifi_address"] as? String ?? ""
                )
                self.userDevice = fetchedUserDevice
                // 存入 Core Data
                self.saveToCoreData(userDevice: fetchedUserDevice)
            } else {
                print("No data found for user UUID: \(userUUID)")
            }
        }
    }

    func saveUserDevice(_ userDevice: UserDevice) {
        dbRef.child("User").child(userDevice.user_uuid).setValue(userDevice.toDictionary()) { error, _ in
            if let error = error {
                print("Error saving user device: \(error.localizedDescription)")
            } else {
                print("User device successfully saved.")
                // 存入 Core Data
                self.saveToCoreData(userDevice: userDevice)
            }
        }
    }

    func saveToCoreData(userDevice: UserDevice) {
        let newUser = User(context: self.context)
        newUser.bluetooth = userDevice.bluetooth
        newUser.eid = userDevice.eid
        newUser.ios_version = userDevice.ios_version
        newUser.iphone_name = userDevice.iphone_name
        newUser.model_number = userDevice.model_number
        newUser.seid = userDevice.seid
        newUser.serial_number = userDevice.serial_number
        newUser.timestamp = userDevice.timestamp
        // 將 String 轉換為 UUID
        if let uuid = UUID(uuidString: userDevice.user_uuid) {
            newUser.user_uuid = uuid
        } else {
            newUser.user_uuid = UUID() // 如果轉換失敗，使用一個新的 UUID
        }
        newUser.wifi_address = userDevice.wifi_address

        do {
            try context.save()
            print("User device successfully saved to Core Data.")
            // 测试从 Core Data 中获取数据
            self.fetchSavedUser(userUUID: newUser.user_uuid!)
        } catch {
            print("Failed to save user device to Core Data: \(error.localizedDescription)")
        }
    }

    func fetchSavedUser(userUUID: UUID) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user_uuid == %@", userUUID as CVarArg)

        do {
            let fetchedUsers = try context.fetch(fetchRequest)
            if let fetchedUser = fetchedUsers.first {
                print("Fetched user device from Core Data:")
                print("Bluetooth: \(fetchedUser.bluetooth ?? "N/A")")
                print("EID: \(fetchedUser.eid ?? "N/A")")
                print("iOS Version: \(fetchedUser.ios_version ?? "N/A")")
                print("iPhone Name: \(fetchedUser.iphone_name ?? "N/A")")
                print("Model Number: \(fetchedUser.model_number ?? "N/A")")
                print("SEID: \(fetchedUser.seid ?? "N/A")")
                print("Serial Number: \(fetchedUser.serial_number ?? "N/A")")
                print("Timestamp: \(fetchedUser.timestamp)")
                print("UUID: \(fetchedUser.user_uuid)")
                print("WiFi Address: \(fetchedUser.wifi_address ?? "N/A")")
            } else {
                print("No user device found with UUID: \(userUUID)")
            }
        } catch {
            print("Failed to fetch user device from Core Data: \(error.localizedDescription)")
        }
    }


    func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingUTF8: ptr)
            }
        }
        return modelCode ?? "Unknown"
    }
    
    func collectDeviceInformation() -> UserDevice {
        let userUUID = UUID().uuidString
        let timestamp = Date().timeIntervalSince1970

        let iosVersion = UIDevice.current.systemVersion
        let iphoneName = UIDevice.current.name
        let modelNumber = getDeviceModel()

        // 無法獲取的信息可以設置為空字符串
        let bluetooth = ""
        let eid = ""
        let seid = ""
        let serialNumber = ""
        let wifiAddress = ""

        return UserDevice(
            bluetooth: bluetooth,
            eid: eid,
            ios_version: iosVersion,
            iphone_name: iphoneName,
            model_number: modelNumber,
            seid: seid,
            serial_number: serialNumber,
            timestamp: timestamp,
            user_uuid: userUUID,
            wifi_address: wifiAddress
        )
    }
}


//import FirebaseDatabase
//import SwiftUI
//import Foundation
//
//class UserDeviceViewModel: ObservableObject {
//    @Published var userDevice: UserDevice?
//    private var dbRef: DatabaseReference
//
//    init() {
//        self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
//    }
//
//    func fetchUserDevice(userUUID: String) {
//        dbRef.child("User").child(userUUID).observeSingleEvent(of: .value) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                self.userDevice = UserDevice(
//                    bluetooth: dict["bluetooth"] as? String ?? "",
//                    eid: dict["eid"] as? String ?? "",
//                    ios_version: dict["ios_version"] as? String ?? "",
//                    iphone_name: dict["iphone_name"] as? String ?? "",
//                    model_number: dict["model_number"] as? String ?? "",
//                    seid: dict["seid"] as? String ?? "",
//                    serial_number: dict["serial_number"] as? String ?? "",
//                    timestamp: dict["timestamp"] as? Double ?? Date().timeIntervalSince1970,
//                    user_uuid: dict["user_uuid"] as? String ?? UUID().uuidString,
//                    wifi_address: dict["wifi_address"] as? String ?? ""
//                )
//            }
//        }
//    }
//
////    func saveUserDevice(_ device: UserDevice) {
////        dbRef.child("User").child(device.user_uuid).setValue(device.toDictionary())
////    }
//    func saveUserDevice(_ device: UserDevice) {
//          dbRef.child("User").child(device.user_uuid).setValue(device.toDictionary()) { error, _ in
//              if let error = error {
//                  print("Error saving user device: \(error.localizedDescription)")
//              } else {
//                  print("User device successfully saved.")
//              }
//          }
//      }
//
//    func getDeviceModel() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
//            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
//                String(validatingUTF8: ptr)
//            }
//        }
//        return modelCode ?? "Unknown"
//    }
//    
//    func collectDeviceInformation() -> UserDevice {
//        let userUUID = UUID().uuidString
//        let timestamp = Date().timeIntervalSince1970
//
//        let iosVersion = UIDevice.current.systemVersion
//        let iphoneName = UIDevice.current.name
//        let modelNumber = getDeviceModel() // 调用上面的函数获取设备型号
//
//        // 无法获取的信息可以设置为空字符串
//        let bluetooth = ""  // 无法获取蓝牙地址
//        let eid = ""  // 无法获取EID
//        let seid = ""  // 无法获取SEID
//        let serialNumber = ""  // 无法获取序列号
//        let wifiAddress = ""  // 无法获取WiFi地址
//
//        return UserDevice(
//            bluetooth: bluetooth,
//            eid: eid,
//            ios_version: iosVersion,
//            iphone_name: iphoneName,
//            model_number: modelNumber,
//            seid: seid,
//            serial_number: serialNumber,
//            timestamp: timestamp,
//            user_uuid: userUUID,
//            wifi_address: wifiAddress
//        )
//    }
//
//    func collectDeviceInformation() -> UserDevice {
//        let userUUID = UUID().uuidString
//        let timestamp = Date().timeIntervalSince1970
//
//        // 获取设备信息
//        let iosVersion = UIDevice.current.systemVersion
//        let iphoneName = UIDevice.current.name
//        let modelNumber = UIDevice.current.model // 这是设备的模型，如 "iPhone"
//        
//        // 获取详细型号信息
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
//            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
//                ptr in String.init(validatingUTF8: ptr)
//            }
//        }
//        let detailedModel = modelCode ?? modelNumber // 如果获取到详细型号就用它，否则使用基本型号
//
//        // 其他信息无法直接获取，设置为空字符串或合适的默认值
//        let bluetooth = "" // 无法获取蓝牙地址
//        let eid = "" // 无法获取EID
//        let seid = "" // 无法获取SEID
//        let serialNumber = "" // 无法获取序列号
//        let wifiAddress = "" // 无法获取WiFi地址
//
//        return UserDevice(
//            bluetooth: bluetooth,
//            eid: eid,
//            ios_version: iosVersion,
//            iphone_name: iphoneName,
//            model_number: detailedModel,
//            seid: seid,
//            serial_number: serialNumber,
//            timestamp: timestamp,
//            user_uuid: userUUID,
//            wifi_address: wifiAddress
//        )
//    }
//}
