//
//  DayData+CoreDataClass.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import CoreData


public class DayData: NSManagedObject {
    
    static internal let entityName = "DayData"
    
    static func insertNewObjectIntoContext(_ objectContext: NSManagedObjectContext) -> DayData {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: objectContext) as! DayData
    }

}
