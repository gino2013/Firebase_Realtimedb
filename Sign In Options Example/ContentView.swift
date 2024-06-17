import SwiftUI

// 主內容視圖，顯示醫療設備列表
struct ContentView: View {
    @ObservedObject var viewModel = MedicalDeviceViewModel() // 觀察ViewModel中的資料變化

    var body: some View {
        NavigationView {
            // 列表顯示所有醫療設備
            List(viewModel.medicalDevices) { device in
                // 每個列表項都有導航鏈接到詳細編輯視圖
                NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: device)) {
                    Text(device.name)
                }
            }
            .navigationBarTitle("Medical Devices") // 設置導航欄標題
        }
    }
}
