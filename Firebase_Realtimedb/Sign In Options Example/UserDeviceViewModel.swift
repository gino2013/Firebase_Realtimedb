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
                    ios_version: dict["ios_version"] as? String ?? "",
                    iphone_name: dict["iphone_name"] as? String ?? "",
                    model_number: dict["model_number"] as? String ?? "",
                    timestamp: dict["timestamp"] as? Double ?? Date().timeIntervalSince1970,
                    user_uuid: dict["user_uuid"] as? String ?? UUID().uuidString,
                    timezone: dict["timezone"] as? String ?? "",
                    screen_size: dict["screen_size"] as? String ?? "",
                    ipv4: dict["ipv4"] as? String ?? "Unavailable",
                    ipv6: dict["ipv6"] as? String ?? "Unavailable",
                    capacity: dict["capacity"] as? String ?? "Unavailable",
                    ram: dict["ram"] as? String ?? "Unavailable",
                    cpu: dict["cpu"] as? String ?? "Unavailable"
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
        // 先检查是否已存在具有相同 user_uuid 的记录
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user_uuid == %@", userDevice.user_uuid)

        do {
            let fetchedUsers = try context.fetch(fetchRequest)
            let userToSave: User

            if let existingUser = fetchedUsers.first {
                // 如果记录存在，更新它
                userToSave = existingUser
            } else {
                // 否则创建一个新的 User 实体
                userToSave = User(context: self.context)
            }

            // 更新或插入数据
            userToSave.ios_version = userDevice.ios_version
            userToSave.iphone_name = userDevice.iphone_name
            userToSave.model_number = userDevice.model_number
            userToSave.timestamp = userDevice.timestamp
            userToSave.user_uuid = UUID(uuidString: userDevice.user_uuid) ?? UUID()
            userToSave.timezone = userDevice.timezone
            userToSave.screen_size = userDevice.screen_size
            userToSave.ipv4 = userDevice.ipv4
            userToSave.ipv6 = userDevice.ipv6
            userToSave.capacity = userDevice.capacity
            userToSave.ram = userDevice.ram
            userToSave.cpu = userDevice.cpu

            // 保存数据
            try context.save()
            print("User device successfully saved to Core Data.")
            // 测试从 Core Data 中获取数据
            self.fetchSavedUser(userUUID: userToSave.user_uuid!)
        } catch {
            print("Failed to save user device to Core Data: \(error.localizedDescription)")
            if let nserror = error as NSError? {
                print("Detailed error: \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchSavedUser(userUUID: UUID) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user_uuid == %@", userUUID as CVarArg)

        do {
            let fetchedUsers = try context.fetch(fetchRequest)
            if let fetchedUser = fetchedUsers.first {
                print("Fetched user device from Core Data:")
                print("iOS Version: \(fetchedUser.ios_version ?? "N/A")")
                print("iPhone Name: \(fetchedUser.iphone_name ?? "N/A")")
                print("Model Number: \(fetchedUser.model_number ?? "N/A")")
                print("Timezone: \(fetchedUser.timezone ?? "N/A")")
                print("Screen Size: \(fetchedUser.screen_size ?? "N/A")")
                print("IPv4 Address: \(fetchedUser.ipv4 ?? "N/A")")
                print("IPv6 Address: \(fetchedUser.ipv6 ?? "N/A")")
                print("Storage Capacity: \(fetchedUser.capacity ?? "N/A")")
                print("RAM: \(fetchedUser.ram ?? "N/A")")
                print("CPU: \(fetchedUser.cpu ?? "N/A")")
                print("Timestamp: \(fetchedUser.timestamp)")
                print("iDFV: \(fetchedUser.user_uuid ?? UUID())")
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
    
    // 获取 IP 地址
    enum IPVersion {
        case ipv4
        case ipv6
    }

    func getIPAddress(for version: IPVersion) -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        // 获取网络接口列表
        if getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr {
            for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
                let interface = ptr.pointee
                let addrFamily = interface.ifa_addr.pointee.sa_family
                let ipVersion = version == .ipv4 ? AF_INET : AF_INET6
                
                // 检查接口名称是否是你所需的
                let name = String(cString: interface.ifa_name)
                if name == "en0" || name == "pdp_ip0" {
                    if addrFamily == UInt8(ipVersion) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        break
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }

    // 获取存储容量
    func getDeviceStorageCapacity() -> String {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let capacity = attributes[.systemSize] as? NSNumber {
                return ByteCountFormatter.string(fromByteCount: capacity.int64Value, countStyle: .file)
            }
        } catch {
            return "Unavailable"
        }
        return "Unavailable"
    }

    // 获取 RAM 大小
    func getDeviceRAM() -> String {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        return ByteCountFormatter.string(fromByteCount: Int64(physicalMemory), countStyle: .memory)
    }

    // 获取 CPU 信息
    func getDeviceCPU() -> String {
        var size = 0
        sysctlbyname("hw.ncpu", nil, &size, nil, 0)
        var ncpu = 0
        sysctlbyname("hw.ncpu", &ncpu, &size, nil, 0)
        return "\(ncpu) cores"
    }
    
    func collectDeviceInformation() -> UserDevice {
        let userUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let timestamp = Date().timeIntervalSince1970

        let iosVersion = UIDevice.current.systemVersion
        let iphoneName = UIDevice.current.name
        let modelNumber = getDeviceModel()

//        // 無法獲取的信息可以設置為空字符串
//        let bluetooth = ""
//        let eid = ""
//        let seid = ""
//        let serialNumber = ""
//        let wifiAddress = ""
        
        // 新增的屬性
        let timezone = TimeZone.current.identifier
        let screenSize = "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
        let ipv4 = getIPAddress(for: .ipv4) ?? "Unavailable"
        let ipv6 = getIPAddress(for: .ipv6) ?? "Unavailable"
        let capacity = getDeviceStorageCapacity()
        let ram = getDeviceRAM()
        let cpu = getDeviceCPU()
        
//        // 打印每个属性
//        print("Timezone: \(timezone)")
//        print("Screen Size: \(screenSize)")
//        print("IPv4 Address: \(ipv4)")
//        print("IPv6 Address: \(ipv6)")
//        print("Storage Capacity: \(capacity)")
//        print("RAM: \(ram)")
//        print("CPU: \(cpu)")

        return UserDevice(
            ios_version: iosVersion,
            iphone_name: iphoneName,
            model_number: modelNumber,
            timestamp: timestamp,
            user_uuid: userUUID,
            timezone: timezone,
            screen_size: screenSize,
            ipv4: ipv4,
            ipv6: ipv6,
            capacity: capacity,
            ram: ram,
            cpu: cpu
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
