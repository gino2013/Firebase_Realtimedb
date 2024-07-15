import FirebaseDatabase
import SwiftUI

// 負責管理醫療設備資料的ViewModel
class MedicalDeviceViewModel: ObservableObject {
    @Published var medicalDevices = [MedicalDevice]() // 儲存所有醫療設備的陣列
    private var dbRef: DatabaseReference // Firebase Realtime Database的參考

    // 初始化，設置資料庫參考並獲取醫療設備資料
    init() {
        self.dbRef = Database.database(url: "https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        fetchMedicalDevices()
    }

    // 從Firebase中獲取醫療設備資料
    func fetchMedicalDevices() {
        // 監聽資料庫中"medicalDevices"節點的變化
        dbRef.child("medicalDevices").observe(.value) { snapshot in
            var devices = [MedicalDevice]()
            // 遍歷快照中的每個子項
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   var device = try? JSONDecoder().decode(MedicalDevice.self, from: jsonData) {
                    device.id = childSnapshot.key // 設置設備的ID
                    devices.append(device) // 將設備添加到陣列中
                }
            }
            self.medicalDevices = devices // 更新ViewModel中的設備列表
        }
    }

    // 更新Firebase中的醫療設備資料
    func updateMedicalDevice(_ device: MedicalDevice) {
        guard let id = device.id else { return }
        // 將設備資料寫回Firebase
        dbRef.child("medicalDevices").child(id).setValue(device.toDictionary())
    }

    // 新增醫療設備資料
    func addMedicalDevice(_ device: MedicalDevice) {
        let newDeviceRef = dbRef.child("medicalDevices").childByAutoId()
        newDeviceRef.setValue(device.toDictionary())
    }

    // 刪除Firebase中的醫療設備資料
    func deleteMedicalDevice(_ device: MedicalDevice) {
        guard let id = device.id else { return }
        dbRef.child("medicalDevices").child(id).removeValue()
    }
}
