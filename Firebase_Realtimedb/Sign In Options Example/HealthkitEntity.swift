import Foundation

struct HealthKitDataEntity: Codable, Identifiable {
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
