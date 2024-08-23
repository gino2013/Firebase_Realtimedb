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
                        Text("Timezone:")
                        TextField("Timezone", text: Binding(
                            get: { deviceInfo.timezone },
                            set: { self.deviceInfo?.timezone = $0 }
                        ))
                    }
                    HStack {
                        Text("Screen Size:")
                        TextField("Screen Size", text: Binding(
                            get: { deviceInfo.screen_size },
                            set: { self.deviceInfo?.screen_size = $0 }
                        ))
                    }
                    HStack {
                        Text("IPv4 Address:")
                        TextField("IPv4 Address", text: Binding(
                            get: { deviceInfo.ipv4 },
                            set: { self.deviceInfo?.ipv4 = $0 }
                        ))
                    }
                    HStack {
                        Text("IPv6 Address:")
                        TextField("IPv6 Address", text: Binding(
                            get: { deviceInfo.ipv6 },
                            set: { self.deviceInfo?.ipv6 = $0 }
                        ))
                    }
                    HStack {
                        Text("Storage Capacity:")
                        TextField("Storage Capacity", text: Binding(
                            get: { deviceInfo.capacity },
                            set: { self.deviceInfo?.capacity = $0 }
                        ))
                    }
                    HStack {
                        Text("RAM:")
                        TextField("RAM", text: Binding(
                            get: { deviceInfo.ram },
                            set: { self.deviceInfo?.ram = $0 }
                        ))
                    }
                    HStack {
                        Text("CPU:")
                        TextField("CPU", text: Binding(
                            get: { deviceInfo.cpu },
                            set: { self.deviceInfo?.cpu = $0 }
                        ))
                    }
                    HStack {
                        Text("IDFV:")
                        TextField("IDFV", text: Binding(
                            get: { deviceInfo.user_uuid },
                            set: { self.deviceInfo?.user_uuid = $0 }
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
                .disabled(deviceInfo.ios_version.isEmpty || deviceInfo.iphone_name.isEmpty) // 这里可以检查必填项是否为空
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
