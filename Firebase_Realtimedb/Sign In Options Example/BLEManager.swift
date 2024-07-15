import CoreBluetooth
import SwiftUI

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    @Published var statusMessage = "Ready"
    @Published var receivedData = "Waiting for data..."
    var onTemperatureUpdate: ((Double) -> Void)?

    let deviceAddress = "1FE8527F-87F3-7D8B-BC84-9BA529FB8BAA"
    let characteristicUUIDs = [CBUUID(string: "0000fff1-0000-1000-8000-00805f9b34fb")]

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    func startScanning() {
        if centralManager.state == .poweredOn {
            statusMessage = "Scanning..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        } else {
            statusMessage = "Bluetooth is not ready."
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusMessage = "Bluetooth is On."
        case .poweredOff:
            statusMessage = "Bluetooth is Off."
        default:
            statusMessage = "Unknown Bluetooth status."
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.identifier.uuidString == deviceAddress {
            self.peripheral = peripheral
            centralManager.stopScan()
            statusMessage = "Found device, connecting to \(peripheral.name ?? "")"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        statusMessage = "Connected to \(peripheral.name ?? "")"
        peripheral.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            peripheral.discoverServices([CBUUID(string: "0000fff0-0000-1000-8000-00805f9b34fb")])
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        let interestedCharacteristicUUIDs = [CBUUID(string: "fff1")]
        for service in services {
            statusMessage = ("Discovered service: \(service.uuid)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                peripheral.discoverCharacteristics(interestedCharacteristicUUIDs, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            statusMessage = ("Characteristic UUID: \(characteristic.uuid), properties: \(characteristic.properties)")
            if characteristic.properties.contains(.read) {
                statusMessage = ("Characteristic \(characteristic.uuid) is readable")
                peripheral.readValue(for: characteristic)
            } else if characteristic.properties.contains(.notify) {
                statusMessage = ("Characteristic \(characteristic.uuid) supports notifications. Subscribing...")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value, characteristic.uuid == CBUUID(string: "0000fff1-0000-1000-8000-00805f9b34fb") {
            let hexString = value.map { String(format: "%02hhx", $0) }.joined()
            
            DispatchQueue.main.async {
                if let convertedData = self.processHexString(hexString) {
                    self.receivedData = String(format: "%.2f°C", convertedData)
                    self.statusMessage = "Received raw data: \(hexString)"
                    self.onTemperatureUpdate?(convertedData)
                } else {
                    self.statusMessage = "Error in processing data."
                }
            }
        }
    }
    
    func processHexString(_ hexString: String) -> Double? {
        guard hexString.count >= 8 else { return nil }
        let startIndex = hexString.index(hexString.startIndex, offsetBy: 10)
        let endIndex = hexString.index(hexString.startIndex, offsetBy: 13)
        let subString = String(hexString[startIndex...endIndex])
        if let firstPart = Int(subString.prefix(2), radix: 16),
           let secondPart = Int(subString.suffix(2), radix: 16) {
            return Double(secondPart) * 0.01 + Double(firstPart)
        } else {
            return nil
        }
    }
}
