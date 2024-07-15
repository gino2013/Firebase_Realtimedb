import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MedicalDeviceViewModel()
    @State private var showingAddDevice = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.medicalDevices) { device in
                    NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: device)) {
                        Text(device.name)
                    }
                }
                .onDelete(perform: deleteDevice)
            }
            .navigationBarTitle("Medical Devices")
            .navigationBarItems(trailing:
                HStack {
                    Button("Add") {
                        showingAddDevice = true
                    }
                    .sheet(isPresented: $showingAddDevice) {
                        AddDeviceView(viewModel: viewModel)
                    }
                    Button("Refresh") {
                        viewModel.fetchMedicalDevices()
                    }
                }
            )
        }
    }

    private func deleteDevice(at offsets: IndexSet) {
        offsets.forEach { index in
            let device = viewModel.medicalDevices[index]
            viewModel.deleteMedicalDevice(device)
        }
    }
}

struct AddDeviceView: View {
    @ObservedObject var viewModel: MedicalDeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var description = ""
    @State private var features = ""
    @State private var measurements = [String: String]()

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Type", text: $type)
                TextField("Brand", text: $brand)
                TextField("Model", text: $model)
                TextField("Description", text: $description)
                TextField("Features (comma separated)", text: $features)
                
                Section(header: Text("Measurements")) {
                    ForEach(measurements.keys.sorted(), id: \.self) { key in
                        HStack {
                            TextField("Measurement Name", text: Binding(
                                get: { key },
                                set: { newKey in
                                    if let value = measurements.removeValue(forKey: key) {
                                        measurements[newKey] = value
                                    }
                                }
                            ))
                            TextField("Value", text: Binding(
                                get: { measurements[key] ?? "" },
                                set: { measurements[key] = $0 }
                            ))
                            .keyboardType(.decimalPad)
                            Button(action: {
                                measurements.removeValue(forKey: key)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Button(action: {
                        measurements[""] = ""
                    }) {
                        Text("Add Measurement")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Add Device", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                let newDevice = MedicalDevice(
                    id: nil,
                    name: name,
                    type: type,
                    brand: brand,
                    model: model,
                    description: description,
                    features: features.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                    measurements: measurements.reduce(into: [Double]()) { result, item in
                        if let value = Double(item.value) {
                            result.append(value)
                        }
                    }
                )
                viewModel.addMedicalDevice(newDevice)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//struct ContentView: View {
//    @StateObject var viewModel = MedicalDeviceViewModel()
//
//    var body: some View {
//        NavigationView {
//            List(viewModel.medicalDevices) { device in
//                NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: device)) {
//                    Text(device.name)
//                }
//            }
//            .navigationBarTitle("Medical Devices")
//            .navigationBarItems(trailing: Button("Refresh") {
//                viewModel.fetchMedicalDevices()
//            })
//        }
//    }
//}

//// 主內容視圖，顯示醫療設備列表
//struct ContentView: View {
//    @ObservedObject var viewModel = MedicalDeviceViewModel() // 觀察ViewModel中的資料變化
//
//    var body: some View {
//        NavigationView {
//            // 列表顯示所有醫療設備
//            List(viewModel.medicalDevices) { device in
//                // 每個列表項都有導航鏈接到詳細編輯視圖
//                NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: device)) {
//                    Text(device.name)
//                }
//            }
//            .navigationBarTitle("Medical Devices") // 設置導航欄標題
//        }
//    }
//}
