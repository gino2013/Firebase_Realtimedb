import SwiftUI
import CoreData

// SwiftUI應用的入口點
@main
struct MedicalDeviceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // 配置AppDelegate以初始化Firebase
    
    // 获取Core Data的context
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext) // 傳遞context給ContentView
        }
    }
}
