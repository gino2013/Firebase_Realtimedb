import SwiftUI

struct DeviceDetailView: View {
    @ObservedObject var viewModel: MedicalDeviceViewModel  // 需要 ViewModel 以进行操作
    @State private var newMeasurementValue = ""           // 用于添加新测量的值
    var device: MedicalDevice

    var body: some View {
        Form {
            Section(header: Text("Device Information")) {
                HStack {
                    Text("Name:").bold()
                    Spacer()
                    Text(device.name)
                }
                HStack {
                    Text("Type:").bold()
                    Spacer()
                    Text(device.type)
                }
                HStack {
                    Text("Brand:").bold()
                    Spacer()
                    Text(device.brand)
                }
                HStack {
                    Text("Model:").bold()
                    Spacer()
                    Text(device.model)
                }
                HStack {
                    Text("Description:").bold()
                    Spacer()
                    Text(device.description)
                }
            }

            Section(header: Text("Features")) {
                ForEach(device.features, id: \.self) { feature in
                    Text(feature)
                }
            }

            Section(header: Text("Measurements")) {
                ForEach(device.measurements.indices, id: \.self) { index in
                    HStack {
                        Text(device.measurements[index].unit)
                        Spacer()
                        Text(device.measurements[index].value)
                    }
                }
                // 添加新测量
                HStack {
                    TextField("New Measurement", text: $newMeasurementValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Button(action: addMeasurement) {
                        Text("Add")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .navigationBarTitle(device.name, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: deleteDevice) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
    }

    // 添加测量数据的功能
    private func addMeasurement() {
        guard !newMeasurementValue.isEmpty else { return }
        let newMeasurement = DeviceMeasurement(
            timestamp: Date().timeIntervalSince1970,
            unit: "Custom Unit",
            value: newMeasurementValue,
            user_uuid: viewModel.currentUserUUID,
            device_uuid: device.id
        )
        
        // 更新设备的测量数据
        if var updatedDevice = viewModel.medicalDevices.first(where: { $0.id == device.id }) {
            updatedDevice.measurements.append(newMeasurement)
            viewModel.updateMedicalDevice(updatedDevice)
        }

        // 清空输入框
        newMeasurementValue = ""
    }

    // 删除设备的功能
    private func deleteDevice() {
        viewModel.deleteMedicalDevice(device)
        // 这里可以选择退出当前视图，或者根据需要进行其他操作
    }
}
