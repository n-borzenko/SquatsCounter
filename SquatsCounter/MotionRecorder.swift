//
//  MotionRecorder.swift
//  SquatsCounter
//
//  Created by Наташа on 26.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionRecorderDelegate : class {
    func recordValue(value: Double)
}

class MotionRecorder {
    
    weak var delegate: MotionRecorderDelegate?
    var motionManager = CMMotionManager()
    var isAvailable: Bool {
        get {
            return motionManager.isDeviceMotionAvailable
        }
    }
    
    init() {
        motionManager.deviceMotionUpdateInterval = 0.1
    }
    
    func motionHandler(motion: CMDeviceMotion) {
        let x = motion.userAcceleration.x
        let y = motion.userAcceleration.y
        let z = motion.userAcceleration.z
        let meanUserAcceleration = sqrt(pow(x, 2.0) + pow(y, 2) + pow(z, 2))
        
        delegate?.recordValue(value: meanUserAcceleration)
    }
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                deviceMotion, error in
                if error == nil {
                    self.motionHandler(motion: deviceMotion!)
                }
            })
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
