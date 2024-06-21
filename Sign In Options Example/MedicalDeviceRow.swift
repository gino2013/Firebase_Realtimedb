import SwiftUI

// 顯示和編輯每個醫療設備的視圖
struct MedicalDeviceRow: View {
    @ObservedObject var viewModel: MedicalDeviceViewModel // 觀察ViewModel中的資料變化
    @State private var device: MedicalDevice // 本地設備資料的狀態

    // 初始化，設置ViewModel和設備資料
    init(viewModel: MedicalDeviceViewModel, device: MedicalDevice) {
        self.viewModel = viewModel
        self._device = State(initialValue: device)
    }

    var body: some View {
        VStack(alignment: .leading) {
            // 顯示和編輯設備名稱
            HStack {
                Text("Name:").bold()
                TextField("Name", text: $device.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 顯示和編輯設備類型
            HStack {
                Text("Type:").bold()
                TextField("Type", text: $device.type)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 顯示和編輯設備品牌
            HStack {
                Text("Brand:").bold()
                TextField("Brand", text: $device.brand)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 顯示和編輯設備型號
            HStack {
                Text("Model:").bold()
                TextField("Model", text: $device.model)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 顯示和編輯設備描述
            HStack {
                Text("Description:").bold()
                TextField("Description", text: $device.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 顯示和編輯設備特性
            HStack {
                Text("Features:").bold()
                TextField("Features", text: Binding(
                    get: { device.features.joined(separator: ", ") },
                    set: { device.features = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // 保存更改按鈕
            Button(action: {
                viewModel.updateMedicalDevice(device)
            }) {
                Text("Save Changes")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .onReceive(viewModel.$medicalDevices) { devices in
            if let updatedDevice = devices.first(where: { $0.id == device.id }) {
                self.device = updatedDevice
            }
        }
    }
}
