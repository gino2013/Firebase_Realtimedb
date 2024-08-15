//
//  Measurement+CoreDataProperties.swift
//  Sign In Options Example
//
//  Created by CFH00892977 on 2024/8/15.
//
//

import Foundation
import CoreData


extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement")
    }

    @NSManaged public var device_uuid: UUID?
    @NSManaged public var timestamp: String?
    @NSManaged public var type: String?
    @NSManaged public var unit: String?
    @NSManaged public var user_uuid: UUID?
    @NSManaged public var value: String?
    @NSManaged public var device: Device?

}

extension Measurement : Identifiable {

}
