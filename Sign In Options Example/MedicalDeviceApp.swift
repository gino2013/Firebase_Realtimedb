import SwiftUI

// SwiftUI應用的入口點
@main
struct MedicalDeviceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // 配置AppDelegate以初始化Firebase

    var body: some Scene {
        WindowGroup {
            ContentView() // 主內容視圖
        }
    }
}
