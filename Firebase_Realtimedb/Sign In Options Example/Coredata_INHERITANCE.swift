import UIKit
import CoreData

func testCoreDataInheritance() {
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    
    // 1. 創建一個新的 StepEntity 實體，繼承自 HealthKitData
    let newStepEntity = StepEntity(context: context)
    newStepEntity.steps = 10000
    newStepEntity.id = UUID()
    newStepEntity.sampleType = "Step"
    newStepEntity.startDate = Date()
    newStepEntity.endDate = Date()
    newStepEntity.user_uuid = UUID() // 假設您有一個用戶的 UUID
    
    // 2. 保存上下文
    persistenceController.saveContext()
    
    // 3. 從 Core Data 中檢索所有 StepEntity 實體
    let fetchRequest: NSFetchRequest<StepEntity> = StepEntity.fetchRequest()
    do {
        let stepEntities = try context.fetch(fetchRequest)
        
        // 4. 確保至少有一個 StepEntity 被保存
        guard stepEntities.count > 0 else {
            print("Error: No StepEntities were fetched.")
            return
        }
        
        // 5. 檢查新創建的 StepEntity 是否存在
        if let fetchedStepEntity = stepEntities.first(where: { $0.id == newStepEntity.id && $0.sampleType == "Step" }) {
            print("Success: StepEntity fetched successfully!")
            print("Steps: \(fetchedStepEntity.steps)")
            print("Sample Type: \(fetchedStepEntity.sampleType ?? "No Sample Type")")
            print("Start Date: \(fetchedStepEntity.startDate)")
            print("End Date: \(fetchedStepEntity.endDate)")
            print("User UUID: \(fetchedStepEntity.user_uuid?.uuidString ?? "No User UUID")")
        } else {
            print("Error: The StepEntity was not fetched correctly.")
        }
    } catch {
        print("Failed to fetch StepEntities: \(error)")
    }
}
