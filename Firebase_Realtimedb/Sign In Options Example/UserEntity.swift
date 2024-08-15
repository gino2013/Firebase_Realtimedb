import Foundation

struct UserEntity: Codable, Identifiable {
    var id: UUID { user_uuid }
    var user_uuid: UUID
    var iphone_name: String
    var ios_version: String
    var model_number: String
    var serial_number: String
    var wifi_address: String
    var bluetooth: String
    var seid: String
    var eid: String

    func toDictionary() -> [String: Any] {
        return [
            "user_uuid": user_uuid.uuidString,
            "iphone_name": iphone_name,
            "ios_version": ios_version,
            "model_number": model_number,
            "serial_number": serial_number,
            "wifi_address": wifi_address,
            "bluetooth": bluetooth,
            "seid": seid,
            "eid": eid
        ]
    }
}
