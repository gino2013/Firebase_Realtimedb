import Foundation

struct DeviceEntity: Codable, Identifiable {
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
