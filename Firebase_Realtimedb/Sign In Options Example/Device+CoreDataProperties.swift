//
//  Device+CoreDataProperties.swift
//  
//
//  Created by CFH00892977 on 2024/8/15.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var brand: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var device_uuid: UUID?
    @NSManaged public var features: String?
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var type: String?
    @NSManaged public var user_uuid: UUID?
    @NSManaged public var measurement: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for measurement
extension Device {

    @objc(addMeasurementObject:)
    @NSManaged public func addToMeasurement(_ value: Measurement)

    @objc(removeMeasurementObject:)
    @NSManaged public func removeFromMeasurement(_ value: Measurement)

    @objc(addMeasurement:)
    @NSManaged public func addToMeasurement(_ values: NSSet)

    @objc(removeMeasurement:)
    @NSManaged public func removeFromMeasurement(_ values: NSSet)

}
