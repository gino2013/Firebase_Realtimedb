import Foundation

// 醫療設備的資料模型，符合 Codable 和 Identifiable 協議
struct MedicalDevice: Codable, Identifiable {
    var id: String?
    var name: String
    var type: String
    var brand: String
    var model: String
    var description: String
    var features: [String]
    var measurements: [DeviceMeasurement]

    // 自定义初始化器
    init(id: String?, name: String, type: String, brand: String, model: String, description: String, features: [String], measurements: [DeviceMeasurement]) {
        self.id = id
        self.name = name
        self.type = type
        self.brand = brand
        self.model = model
        self.description = description
        self.features = features
        self.measurements = measurements
    }

    // 从字典初始化
    init(from dictionary: [String: Any], id: String) {
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.brand = dictionary["brand"] as? String ?? ""
        self.model = dictionary["model"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.features = dictionary["features"] as? [String] ?? []
        
        // 解析 measurements
        if let measurementsArray = dictionary["measurements"] as? [[String: Any]] {
            self.measurements = measurementsArray.map { DeviceMeasurement(from: $0) }
        } else {
            self.measurements = []
        }
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "type": type,
            "brand": brand,
            "model": model,
            "description": description,
            "features": features,
            "measurements": measurements.map { $0.toDictionary() }
        ]
    }
}

// 醫療設備的量測數值模型，符合 Codable 協議
struct DeviceMeasurement: Codable {
    var timestamp: Double
    var unit: String
    var value: String
    var user_uuid: String?
    var device_uuid: String?

    init(timestamp: Double, unit: String, value: String, user_uuid: String?, device_uuid: String?) {
        self.timestamp = timestamp
        self.unit = unit
        self.value = value
        self.user_uuid = user_uuid
        self.device_uuid = device_uuid
    }

    // 从字典初始化
    init(from dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Double ?? 0
        self.unit = dictionary["unit"] as? String ?? ""
        self.value = dictionary["value"] as? String ?? ""
        self.user_uuid = dictionary["user_uuid"] as? String
        self.device_uuid = dictionary["device_uuid"] as? String
    }

    func toDictionary() -> [String: Any] {
        return [
            "timestamp": timestamp,
            "unit": unit,
            "value": value,
            "user_uuid": user_uuid ?? "",
            "device_uuid": device_uuid ?? ""
        ]
    }
}
