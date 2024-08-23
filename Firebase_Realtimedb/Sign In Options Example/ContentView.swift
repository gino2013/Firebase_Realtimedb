import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel: MedicalDeviceViewModel
    @StateObject var userDeviceViewModel: UserDeviceViewModel
    @State private var showingAddDevice = false
    @State private var showingUserDeviceInfo = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MedicalDeviceViewModel())
        _userDeviceViewModel = StateObject(wrappedValue: UserDeviceViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.medicalDevices.indices, id: \.self) { index in
                    NavigationLink(
                        destination: DeviceDetailView(viewModel: viewModel, device: viewModel.medicalDevices[index])
                    ) {
                        Text(viewModel.medicalDevices[index].name)
                    }
                }
                .onDelete(perform: deleteDevice)

                NavigationLink(
                    destination: UserDeviceInfoView(viewModel: userDeviceViewModel),
                    isActive: $showingUserDeviceInfo
                ) {
                    Text("View Device Info")
                }
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
                    Button("Device Info") {
                        showingUserDeviceInfo = true
                    }
                    Button("Refresh") {
                        viewModel.fetchMedicalDevices()
                    }
                }
            )
        }
        .onAppear {
            viewModel.fetchMedicalDevices()
        }
    }

    private func deleteDevice(at offsets: IndexSet) {
        offsets.forEach { index in
            let device = viewModel.medicalDevices[index]
            viewModel.deleteMedicalDevice(device)
        }
    }
}




//struct ContentView: View {
//    @StateObject var viewModel = MedicalDeviceViewModel()
//    @State private var showingAddDevice = false
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.medicalDevices.indices, id: \.self) { index in
//                    NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: $viewModel.medicalDevices[index])) {
//                        Text(viewModel.medicalDevices[index].name)
//                    }
//                }
//                .onDelete(perform: deleteDevice)
//            }
//            .navigationBarTitle("Medical Devices")
//            .navigationBarItems(trailing:
//                HStack {
//                    Button("Add") {
//                        showingAddDevice = true
//                    }
//                    .sheet(isPresented: $showingAddDevice) {
//                        AddDeviceView(viewModel: viewModel)
//                    }
//                    Button("Refresh") {
//                        viewModel.fetchMedicalDevices()
//                    }
//                }
//            )
//        }
//        .onAppear {
//            viewModel.fetchMedicalDevices()
//        }
//    }
//
//    private func deleteDevice(at offsets: IndexSet) {
//        offsets.forEach { index in
//            let device = viewModel.medicalDevices[index]
//            viewModel.deleteMedicalDevice(device)
//        }
//    }
//}

//struct ContentView: View {
//    @StateObject var viewModel = MedicalDeviceViewModel()
//    @State private var showingAddDevice = false
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.medicalDevices.indices, id: \.self) { index in
//                    NavigationLink(destination: MedicalDeviceRow(viewModel: viewModel, device: $viewModel.medicalDevices[index])) {
//                        Text(viewModel.medicalDevices[index].name)
//                    }
//                }
//                .onDelete(perform: deleteDevice)
//            }
//            .navigationBarTitle("Medical Devices")
//            .navigationBarItems(trailing:
//                HStack {
//                    Button("Add") {
//                        showingAddDevice = true
//                    }
//                    .sheet(isPresented: $showingAddDevice) {
//                        AddDeviceView(viewModel: viewModel)
//                    }
//                    Button("Refresh") {
//                        viewModel.fetchMedicalDevices()
//                    }
//                }
//            )
//        }
//    }
//
//    private func deleteDevice(at offsets: IndexSet) {
//        offsets.forEach { index in
//            let device = viewModel.medicalDevices[index]
//            viewModel.deleteMedicalDevice(device)
//        }
//    }
//}

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
                    measurements: measurements.map { DeviceMeasurement(timestamp: Date().timeIntervalSince1970, unit: $0.key, value: $0.value, user_uuid: viewModel.currentUserUUID, device_uuid: nil) }
                )
                viewModel.addMedicalDevice(newDevice)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

