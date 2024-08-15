import Foundation

struct MeasurementEntity: Codable, Identifiable {
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
