//
//  Sampler.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

public final class TimeIntervalSampler {
    public let maxTimeInterval: TimeInterval
    private var lastSampleDate = Date()
    
    public init(_ maxTimeInterval: TimeInterval) {
        self.maxTimeInterval = maxTimeInterval
    }
    
    public func trySample() -> Bool {
        guard abs(lastSampleDate.timeIntervalSinceNow) > maxTimeInterval else { return false }
        lastSampleDate = Date()
        return true
    }
    
    public func callAsFunction() -> Bool {
        trySample()
    }
}
