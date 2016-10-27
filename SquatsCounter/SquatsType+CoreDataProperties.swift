//
//  SquatsType+CoreDataProperties.swift
//  SquatsCounter
//
//  Created by Наташа on 18.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import CoreData

extension SquatsType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SquatsType> {
        return NSFetchRequest<SquatsType>(entityName: "SquatsType");
    }

    @NSManaged public var color: NSData?
    @NSManaged public var name: String?
    @NSManaged public var day: NSSet?

}

// MARK: Generated accessors for day
extension SquatsType {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: DayData)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: DayData)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}
