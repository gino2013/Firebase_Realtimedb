import SwiftUI

struct DeviceDetailView: View {
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
            }
        }
        .navigationBarTitle(device.name, displayMode: .inline)
    }
}
