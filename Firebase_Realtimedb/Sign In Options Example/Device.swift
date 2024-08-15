import Foundation

struct Device: Codable, Identifiable {
    var id: UUID { device_uuid }
    var device_uuid: UUID
    var brand: String
    var description: String
    var features: String
    var model: String
    var name: String
    var type: String
    var user_uuid: UUID

    func toDictionary() -> [String: Any] {
        return [
            "device_uuid": device_uuid.uuidString,
            "brand": brand,
            "description": description,
            "features": features,
            "model": model,
            "name": name,
            "type": type,
            "user_uuid": user_uuid.uuidString
        ]
    }
}

struct Measurement: Codable, Identifiable {
    var id: Double { timestamp }
    var timestamp: Double
    var user_uuid: UUID
    var device_uuid: UUID
    var unit: String
    var value: String

    func toDictionary() -> [String: Any] {
        return [
            "timestamp": timestamp,
            "user_uuid": user_uuid.uuidString,
            "device_uuid": device_uuid.uuidString,
            "unit": unit,
            "value": value
        ]
    }
}

struct HealthKitData: Codable, Identifiable {
    var id: Double { timestamp }
    var timestamp: Double
    var user_uuid: UUID
    var type: String
    var unit: String
    var value: String

    func toDictionary() -> [String: Any] {
        return [
            "timestamp": timestamp,
            "user_uuid": user_uuid.uuidString,
            "type": type,
            "unit": unit,
            "value": value
        ]
    }
}
