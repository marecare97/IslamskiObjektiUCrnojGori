//
//  PhoneRotationManager.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 20.6.23..
//

import Foundation
import Combine
import CoreMotion

class PhoneRotationManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var cancellables = Set<AnyCancellable>()
    @Published var rotation: Double = 0.0
    
    init() {
        startRotationUpdates()
    }
    
    private func startRotationUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            // Handle error or unsupported device
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1 // Adjust the update interval as per your requirements
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion else {
                // Handle error
                return
            }
            
            DispatchQueue.main.async {
                self?.rotation = motion.attitude.yaw * (180 / .pi)
            }
        }
    }
    
    func stopRotationUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
