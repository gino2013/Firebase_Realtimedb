import FirebaseDatabase
import SwiftUI
import Foundation

class UserDeviceViewModel: ObservableObject {
    @Published var userDevice: UserDevice?
    private var dbRef: DatabaseReference

    init() {
        self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }

    func fetchUserDevice(userUUID: String) {
        dbRef.child("User").child(userUUID).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                self.userDevice = UserDevice(
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
            }
        }
    }

    func saveUserDevice(_ device: UserDevice) {
        dbRef.child("User").child(device.user_uuid).setValue(device.toDictionary())
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
        let modelNumber = getDeviceModel() // 调用上面的函数获取设备型号

        // 无法获取的信息可以设置为空字符串
        let bluetooth = ""  // 无法获取蓝牙地址
        let eid = ""  // 无法获取EID
        let seid = ""  // 无法获取SEID
        let serialNumber = ""  // 无法获取序列号
        let wifiAddress = ""  // 无法获取WiFi地址

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
}
