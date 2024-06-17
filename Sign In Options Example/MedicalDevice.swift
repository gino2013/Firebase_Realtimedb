import Foundation

// 醫療設備的資料模型，符合Codable和Identifiable協議
struct MedicalDevice: Codable, Identifiable {
    var id: String? // Firebase中的唯一標識符
    var name: String // 設備名稱
    var type: String // 設備類型
    var brand: String // 設備品牌
    var model: String // 設備型號
    var description: String // 設備描述
    var features: [String] // 設備特性列表

    // 將模型轉換為字典，以便存儲到Firebase
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "type": type,
            "brand": brand,
            "model": model,
            "description": description,
            "features": features
        ]
    }
}
