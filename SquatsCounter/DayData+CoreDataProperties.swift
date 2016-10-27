//
//  DayData+CoreDataProperties.swift
//  SquatsCounter
//
//  Created by Наташа on 18.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import CoreData

extension DayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayData> {
        return NSFetchRequest<DayData>(entityName: "DayData");
    }

    @NSManaged public var count: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var squatsType: SquatsType?

}
