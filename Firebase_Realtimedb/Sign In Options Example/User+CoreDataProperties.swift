//
//  User+CoreDataProperties.swift
//  
//
//  Created by CFH00892977 on 2024/8/15.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bluetooth: String?
    @NSManaged public var eid: String?
    @NSManaged public var ios_version: String?
    @NSManaged public var iphone_name: String?
    @NSManaged public var model_number: String?
    @NSManaged public var seid: String?
    @NSManaged public var serial_number: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var user_uuid: UUID?
    @NSManaged public var wifi_address: String?
    @NSManaged public var device: NSOrderedSet?
    @NSManaged public var healthkit: NSSet?

}

// MARK: Generated accessors for device
extension User {

    @objc(insertObject:inDeviceAtIndex:)
    @NSManaged public func insertIntoDevice(_ value: Device, at idx: Int)

    @objc(removeObjectFromDeviceAtIndex:)
    @NSManaged public func removeFromDevice(at idx: Int)

    @objc(insertDevice:atIndexes:)
    @NSManaged public func insertIntoDevice(_ values: [Device], at indexes: NSIndexSet)

    @objc(removeDeviceAtIndexes:)
    @NSManaged public func removeFromDevice(at indexes: NSIndexSet)

    @objc(replaceObjectInDeviceAtIndex:withObject:)
    @NSManaged public func replaceDevice(at idx: Int, with value: Device)

    @objc(replaceDeviceAtIndexes:withDevice:)
    @NSManaged public func replaceDevice(at indexes: NSIndexSet, with values: [Device])

    @objc(addDeviceObject:)
    @NSManaged public func addToDevice(_ value: Device)

    @objc(removeDeviceObject:)
    @NSManaged public func removeFromDevice(_ value: Device)

    @objc(addDevice:)
    @NSManaged public func addToDevice(_ values: NSOrderedSet)

    @objc(removeDevice:)
    @NSManaged public func removeFromDevice(_ values: NSOrderedSet)

}

// MARK: Generated accessors for healthkit
extension User {

    @objc(addHealthkitObject:)
    @NSManaged public func addToHealthkit(_ value: HealthKitData)

    @objc(removeHealthkitObject:)
    @NSManaged public func removeFromHealthkit(_ value: HealthKitData)

    @objc(addHealthkit:)
    @NSManaged public func addToHealthkit(_ values: NSSet)

    @objc(removeHealthkit:)
    @NSManaged public func removeFromHealthkit(_ values: NSSet)

}
