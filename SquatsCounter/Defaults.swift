//
//  Defaults.swift
//  SquatsCounter
//
//  Created by Наташа on 25.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation

class Defaults {
    
    static var defaults = UserDefaults.standard
    
    static var hasFirstRecord: Bool {
        get {
            return defaults.bool(forKey: "hasFirstRecord")
        }
        set {
            defaults.set(newValue, forKey: "hasFirstRecord")
        }
    }
    
    static var isAnalyzed: Bool {
        let calendar = Calendar.current
        if let date = currentDate {
            return calendar.isDateInToday(date)
        } else {
            return false
        }
    }
    
    static var storedMeanValue: Double {
        get {
            return defaults.double(forKey: "storedMeanValue")
        }
        set {
            defaults.set(newValue, forKey: "storedMeanValue")
        }
    }
    
    static var storedMinPeakValue: Double {
        get {
            return defaults.double(forKey: "storedMinPeakValue")
        }
        set {
            defaults.set(newValue, forKey: "storedMinPeakValue")
        }
    }
    
    static var storedInterval: Int {
        get {
            return defaults.integer(forKey: "storedInterval")
        }
        set {
            defaults.set(newValue, forKey: "storedInterval")
        }
    }
    
    static var storedSquatsTypeID: URL {
        get {
            let data = defaults.object(forKey: "storedSquatsTypeID") as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: data) as! URL
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            defaults.set(data, forKey: "storedSquatsTypeID")
        }
    }
    
    static var currentDate: Date? {
        get {
            return defaults.object(forKey: "currentDate") as? Date
        }
        set {
            if let date = newValue {
                let calendar = Calendar.current
                defaults.set(calendar.startOfDay(for: date), forKey: "currentDate")
            } else {
                defaults.set(newValue, forKey: "currentDate")
            }
        }
    }
    
}
