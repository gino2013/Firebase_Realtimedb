import SwiftUI

struct MedicalDeviceRow: View {
    @ObservedObject var viewModel: MedicalDeviceViewModel // 觀察ViewModel中的資料變化
    @Binding var device: MedicalDevice // 本地設備資料的狀態
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditingField = [String: Bool]() // 追蹤每個欄位是否在編輯狀態

    // 初始化，設置ViewModel和設備資料
    init(viewModel: MedicalDeviceViewModel, device: Binding<MedicalDevice>) {
        self.viewModel = viewModel
        self._device = device
    }

    var body: some View {
        VStack(alignment: .leading) {
            // 顯示和編輯設備名稱
            HStack {
                Text("Name:").bold()
                TextField("Name", text: $device.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    withAnimation {
                        isEditingField["name", default: false].toggle()
                    }
                }) {
                    Image(systemName: isEditingField["name", default: false] ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            if isEditingField["name", default: false] {
                Button(action: {
                    device.name = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            }

            // 顯示和編輯設備類型
            HStack {
                Text("Type:").bold()
                TextField("Type", text: $device.type)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    withAnimation {
                        isEditingField["type", default: false].toggle()
                    }
                }) {
                    Image(systemName: isEditingField["type", default: false] ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            if isEditingField["type", default: false] {
                Button(action: {
                    device.type = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            }

            // 顯示和編輯設備品牌
            HStack {
                Text("Brand:").bold()
                TextField("Brand", text: $device.brand)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    withAnimation {
                        isEditingField["brand", default: false].toggle()
                    }
                }) {
                    Image(systemName: isEditingField["brand", default: false] ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            if isEditingField["brand", default: false] {
                Button(action: {
                    device.brand = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            }

            // 顯示和編輯設備型號
            HStack {
                Text("Model:").bold()
                TextField("Model", text: $device.model)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    withAnimation {
                        isEditingField["model", default: false].toggle()
                    }
                }) {
                    Image(systemName: isEditingField["model", default: false] ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            if isEditingField["model", default: false] {
                Button(action: {
                    device.model = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            }

            // 顯示和編輯設備描述
            HStack {
                Text("Description:").bold()
                TextField("Description", text: $device.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    withAnimation {
                        isEditingField["description", default: false].toggle()
                    }
                }) {
                    Image(systemName: isEditingField["description", default: false] ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            if isEditingField["description", default: false] {
                Button(action: {
                    device.description = ""
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            }

            // 顯示和編輯設備特性
            VStack(alignment: .leading) {
                Text("Features:").bold()
                ForEach(device.features.indices, id: \.self) { index in
                    HStack {
                        TextField("Feature", text: Binding(
                            get: { device.features[index] },
                            set: { device.features[index] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            device.features.remove(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                Button(action: {
                    device.features.append("")
                }) {
                    Text("Add Feature")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }

            // 顯示和編輯量測數值
            VStack(alignment: .leading) {
                Text("Measurements:").bold()
                ForEach(device.measurements.indices, id: \.self) { index in
                    HStack {
                        TextField("Measurement", value: Binding(
                            get: { device.measurements[index].value },
                            set: { device.measurements[index].value = $0 }
                        ), formatter: doubleFormatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            device.measurements.remove(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                Button(action: {
                    device.measurements.append(DeviceMeasurement(timestamp: Date().timeIntervalSince1970, unit: "default", value: "", user_uuid: viewModel.currentUserUUID, device_uuid: device.id))
                }) {
                    Text("Add Measurement")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
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
            
            // 刪除整個設備的按鈕
            Button(action: {
                viewModel.deleteMedicalDevice(device)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
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

private var doubleFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
}

