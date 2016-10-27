//
//  Counter.swift
//  SquatsCounter
//
//  Created by Наташа on 26.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import Surge

class Counter {

    // MARK: - Initialization
    
    var meanValue: Double!
    var minPeakValue: Double!
    var interval: Int!
    
    let intervalPercent = 0.70
    let minPeakValuePercent = 0.85
    
    init(meanValue: Double, minPeakValue: Double, interval: Int) {
        self.meanValue = meanValue
        self.minPeakValue = minPeakValue
        self.interval = interval
    }
    
    init?(array: [Double]) {
        let minValue = min(array)
        let maxValue = max(array)
        
        if abs(abs(maxValue) - abs(minValue)) < 0.2 {
            return nil
        }
        
        meanValue = mean(array)
        minPeakValue = meanValue
        
        var peaks = [(offset: Int, element: Double)]()
        
        var currentPeak = (offset: 0, element: 0.0)
        var isSearchingPeak = false
        for item in array.enumerated() {
            if !isSearchingPeak && item.element > minPeakValue {
                isSearchingPeak = true
            }
            
            if isSearchingPeak && item.element > currentPeak.element {
                currentPeak = item
            }
            
            if isSearchingPeak && item.element < meanValue {
                isSearchingPeak = false
                peaks.append(currentPeak)
                currentPeak = (offset: 0, element: 0.0)
            }
        }
        
        if peaks.count < 3 {
            return nil
        }
        
        var realPeaks = peaks.sorted(by: { $0.element > $1.element }).prefix(3).sorted(by: { $0.offset > $1.offset })
        interval = (realPeaks[0].offset - realPeaks[1].offset) + (realPeaks[1].offset - realPeaks[2].offset)
        interval = Int(Double(interval / 2) * intervalPercent)
        minPeakValue = (realPeaks.min(by: { $0.element < $1.element })!.element) * minPeakValuePercent
    }
    
    // MARK: - Counting
    
    var currentPeak : (offset: Int, element: Double)?
    var minIntervalOffset = 0
    var peakValue = 0.0
    var isSearchingPeak = false
    var offset = 0
    
    func clear() {
        currentPeak = nil
        minIntervalOffset = 0
        peakValue = minPeakValue
        isSearchingPeak = false
        offset = 0
    }
    
    func check(item: Double) -> Bool {
        var isPeak = false
        if !isSearchingPeak && item > minPeakValue {
            isSearchingPeak = true
        }
        
        if isSearchingPeak && offset > minIntervalOffset && item > peakValue {
            currentPeak = (offset: offset, element: item)
            peakValue = item
        }
        
        if isSearchingPeak && item < meanValue {
            isSearchingPeak = false
            if let current = currentPeak {
                minIntervalOffset = current.offset + interval
                peakValue = minPeakValue
                
                currentPeak = nil
                isPeak = true
            }
        }
        
        offset += 1
        return isPeak
    }
}
