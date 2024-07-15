import SwiftUI
import FirebaseCore

// AppDelegate類負責應用程式的啟動設置
class AppDelegate: NSObject, UIApplicationDelegate {
    // 應用程式啟動時調用
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 配置Firebase
        FirebaseApp.configure()
        return true
    }
}
