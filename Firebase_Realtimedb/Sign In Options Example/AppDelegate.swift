import SwiftUI
import FirebaseCore
import CoreData

// AppDelegate類負責應用程式的啟動設置
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var userDeviceViewModel: UserDeviceViewModel? // 声明 userDeviceViewModel 变量
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "LocalData") // 使用你的 Core Data 模型名称
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    // 應用程式啟動時調用
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 配置Firebase
        FirebaseApp.configure()
        testCoreDataFunctionality()
        testCoreDataInheritance() 
        
        // 获取 Core Data 的上下文
        let context = persistentContainer.viewContext
        
        // 创建 UserDeviceViewModel 实例
        userDeviceViewModel = UserDeviceViewModel(context: context)

        // 收集设备信息
        if let deviceInfo = userDeviceViewModel?.collectDeviceInformation() {
           // 保存设备信息到 Firebase 和 Core Data
           userDeviceViewModel?.saveUserDevice(deviceInfo)
        }

        return true
    }
    
    // 保存Core Data上下文
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceController.shared.saveContext()
    }
}
 
