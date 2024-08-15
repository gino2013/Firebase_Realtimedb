//
//  HealthKitData+CoreDataProperties.swift
//  
//
//  Created by CFH00892977 on 2024/8/15.
//
//

import Foundation
import CoreData


extension HealthKitData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HealthKitData> {
        return NSFetchRequest<HealthKitData>(entityName: "HealthKitData")
    }

    @NSManaged public var source: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var type: String?
    @NSManaged public var unit: String?
    @NSManaged public var user_uuid: UUID?
    @NSManaged public var value: String?
    @NSManaged public var user: User?

}
