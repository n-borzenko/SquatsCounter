//
//  SquatsType+CoreDataClass.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import CoreData


public class SquatsType: NSManagedObject {
    
    static internal let entityName = "SquatsType"
    
    static func insertNewObjectIntoContext(_ objectContext: NSManagedObjectContext) -> SquatsType {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: objectContext) as! SquatsType
    }
    
    static func sortedfetchRequest() -> NSFetchRequest<SquatsType> {
        let fetchRequest = NSFetchRequest<SquatsType>(entityName: "SquatsType")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
