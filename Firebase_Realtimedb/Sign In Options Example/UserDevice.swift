import Foundation

struct UserDevice: Codable {
    var ios_version: String
    var iphone_name: String
    var model_number: String
    var timestamp: Double
    var user_uuid: String
    
    var timezone: String
    var screen_size: String
    var ipv4: String
    var ipv6: String
    var capacity: String
    var ram: String
    var cpu: String
    
    func toDictionary() -> [String: Any] {
        return [
            "ios_version": ios_version,
            "iphone_name": iphone_name,
            "model_number": model_number,
            "timestamp": timestamp,
            "user_uuid": user_uuid,
            "timezone": timezone,
            "screen_size": screen_size,
            "ipv4": ipv4,
            "ipv6": ipv6,
            "capacity": capacity,
            "ram": ram,
            "cpu": cpu
        ]
    }
}
