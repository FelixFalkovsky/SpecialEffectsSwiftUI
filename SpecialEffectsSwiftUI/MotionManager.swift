//
//  MotionManager.swift
//  SpecialEffectsSwiftUI
//
//  Created by Felix on 29.01.2022.
//

import CoreMotion

class MotionManager {
   
    // Update coordinate state when using device tilt
    //private var motionManager = CMMotionManager()
    
   // Update the state of the coordinates without changing the location of the device
   // For testing, you need to wear AirPods
    private var motionManager = CMHeadphoneMotionManager()
    
    var pitch = 0.0
    var roll = 0.0
    var yaw = 0.0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
            self.yaw = motion.attitude.yaw
        }
    }
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
