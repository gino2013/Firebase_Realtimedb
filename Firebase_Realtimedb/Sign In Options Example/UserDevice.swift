import Foundation

struct UserDevice: Codable {
    var bluetooth: String
    var eid: String
    var ios_version: String
    var iphone_name: String
    var model_number: String
    var seid: String
    var serial_number: String
    var timestamp: Double
    var user_uuid: String
    var wifi_address: String
    
    func toDictionary() -> [String: Any] {
        return [
            "bluetooth": bluetooth,
            "eid": eid,
            "ios_version": ios_version,
            "iphone_name": iphone_name,
            "model_number": model_number,
            "seid": seid,
            "serial_number": serial_number,
            "timestamp": timestamp,
            "user_uuid": user_uuid,
            "wifi_address": wifi_address
        ]
    }
}
