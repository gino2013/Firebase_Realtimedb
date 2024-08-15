import UIKit
import CoreData

func testCoreDataFunctionality() {
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    
    // 1. 創建一個新的 Device 實體
    let newDevice = Device(context: context)
    newDevice.name = "Test Device"
    newDevice.brand = "Test Brand"
    newDevice.device_uuid = UUID()
    
    // 2. 保存上下文
    persistenceController.saveContext()
    
    // 3. 從 Core Data 中檢索所有 Device 實體
    let fetchRequest: NSFetchRequest<Device> = Device.fetchRequest()
    do {
        let devices = try context.fetch(fetchRequest)
        
        // 4. 確保至少有一個 Device 被保存
        guard devices.count > 0 else {
            print("Error: No devices were fetched.")
            return
        }
        
        // 5. 檢查新創建的 Device 是否存在
        if let fetchedDevice = devices.first(where: { $0.name == "Test Device" && $0.brand == "Test Brand" }) {
            print("Success: Device fetched successfully!")
            print("Device name: \(fetchedDevice.name ?? "No Name")")
            print("Device brand: \(fetchedDevice.brand ?? "No Brand")")
        } else {
            print("Error: The device was not fetched correctly.")
        }
    } catch {
        print("Failed to fetch devices: \(error)")
    }
}
