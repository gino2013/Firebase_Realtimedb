import SwiftUI

struct UserDeviceInfoView: View {
    @ObservedObject var viewModel: UserDeviceViewModel
    @State private var deviceInfo: UserDevice?
    @State private var isSaving: Bool = false  // 用于指示保存状态

    var body: some View {
        Form {
            if let deviceInfo = deviceInfo {  // 确保 deviceInfo 已被赋值
                Section(header: Text("User Device Information")) {
                    HStack {
                        Text("Bluetooth:")
                        TextField("Bluetooth", text: Binding(
                            get: { deviceInfo.bluetooth },
                            set: { self.deviceInfo?.bluetooth = $0 }
                        ))
                    }
                    HStack {
                        Text("EID:")
                        TextField("EID", text: Binding(
                            get: { deviceInfo.eid },
                            set: { self.deviceInfo?.eid = $0 }
                        ))
                    }
                    HStack {
                        Text("iOS Version:")
                        TextField("iOS Version", text: Binding(
                            get: { deviceInfo.ios_version },
                            set: { self.deviceInfo?.ios_version = $0 }
                        ))
                    }
                    HStack {
                        Text("iPhone Name:")
                        TextField("iPhone Name", text: Binding(
                            get: { deviceInfo.iphone_name },
                            set: { self.deviceInfo?.iphone_name = $0 }
                        ))
                    }
                    HStack {
                        Text("Model Number:")
                        TextField("Model Number", text: Binding(
                            get: { deviceInfo.model_number },
                            set: { self.deviceInfo?.model_number = $0 }
                        ))
                    }
                    HStack {
                        Text("SEID:")
                        TextField("SEID", text: Binding(
                            get: { deviceInfo.seid },
                            set: { self.deviceInfo?.seid = $0 }
                        ))
                    }
                    HStack {
                        Text("Serial Number:")
                        TextField("Serial Number", text: Binding(
                            get: { deviceInfo.serial_number },
                            set: { self.deviceInfo?.serial_number = $0 }
                        ))
                    }
                    HStack {
                        Text("WiFi Address:")
                        TextField("WiFi Address", text: Binding(
                            get: { deviceInfo.wifi_address },
                            set: { self.deviceInfo?.wifi_address = $0 }
                        ))
                    }
                }

                Button(action: {
                    isSaving = true
                    if let device = self.deviceInfo {
                        viewModel.saveUserDevice(device)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isSaving = false  // 模拟保存完成后的反馈
                    }
                }) {
                    Text(isSaving ? "Saving..." : "Save to Firebase")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isSaving ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .scaleEffect(isSaving ? 0.95 : 1.0)  // 按下时稍微缩小按钮
                }
                .disabled(deviceInfo.bluetooth.isEmpty || deviceInfo.eid.isEmpty) // 这里可以检查必填项是否为空
            } else {
                Text("Loading device information...")
            }
        }
        .navigationBarTitle("Device Info", displayMode: .inline)
        .onAppear {
            // 自动收集设备信息并保存
            let newDeviceInfo = viewModel.collectDeviceInformation()
            self.deviceInfo = newDeviceInfo
            viewModel.saveUserDevice(newDeviceInfo)  // 自动保存信息到 Firebase
        }
    }
}
