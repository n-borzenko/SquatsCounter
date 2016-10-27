//
//  DayManager.swift
//  SquatsCounter
//
//  Created by Наташа on 26.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import CoreData

struct Day {
    var date: String
    var count: Double
    var color: UIColor?
    var order: Int
}

class DayManager {
    
    static var sharedInstance = DayManager()
    
    var context: NSManagedObjectContext!
    
    var maxSquatsCount: Int {
        get {
            let fetchRequest = NSFetchRequest<DayData>(entityName: "DayData")
            fetchRequest.fetchLimit = 1
            let sortDescriptor = NSSortDescriptor(key: "count", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let result = try context.fetch(fetchRequest)
                return result.count > 0 ? Int(result[0].count) + 5 : 20
            } catch {
                return 20
            }
        }
    }
    
    func getTenDays(fromNow: Int) -> [Day] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 10 * fromNow, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -9, to: endDate)!
        
        let fetchRequest = NSFetchRequest<DayData>(entityName: "DayData")
        let predicate = NSPredicate(format: "%K >= %@ AND %K <= %@", "date", startDate as CVarArg, "date", endDate as CVarArg)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var result: [DayData]
        do {
            result = try context.fetch(fetchRequest)
        } catch {
            result = [DayData]()
        }
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd.MM"
        
        var days = [Day]()
        var currentDay = result.popLast()
        
        for i in 0...9 {
            let date = calendar.date(byAdding: .day, value: i, to: startDate)!
            if let current = currentDay, date == current.date as! Date {
                let color = NSKeyedUnarchiver.unarchiveObject(with: current.squatsType?.color as! Data) as! UIColor
                days.append(Day(date: formatter.string(from: date), count: Double(current.count), color: color, order: i + 1))
                currentDay = result.popLast()
            } else {
                days.append(Day(date: formatter.string(from: date), count: 0, color: nil, order: i + 1))
            }
        }
        return days        
    }
    
    func appendSquats(count: Int, type: SquatsType) {
        let fetchRequest = NSFetchRequest<DayData>(entityName: "DayData")
        let date = Defaults.currentDate! as NSDate
        let predicate = NSPredicate(format: "%K == %@", "date", date)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count == 1 {
                result[0].count += count
            } else {
                let dayData = DayData.insertNewObjectIntoContext(context)
                dayData.count = Int32(count)
                dayData.date = Defaults.currentDate! as NSDate
                dayData.squatsType = type
            }
            
            try context.save()
        } catch {
        }
    }
}
