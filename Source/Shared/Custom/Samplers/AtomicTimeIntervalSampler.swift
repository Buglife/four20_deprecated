//
//  Sampler.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

public final class AtomicTimeIntervalSampler {
    public let maxTimeInterval: TimeInterval
    private var unsafeLastSampleDate = Date(timeIntervalSince1970: 0)
    private let readWriteQueue = DispatchQueue(label: "readWriteQueue")
    
    public init(_ maxTimeInterval: TimeInterval) {
        self.maxTimeInterval = maxTimeInterval
    }
    
    public func trySample() -> Bool {
        var result = false
        
        readWriteQueue.sync { [weak self] in
            guard let strongSelf = self else { return }
            guard abs(strongSelf.unsafeLastSampleDate.timeIntervalSinceNow) > strongSelf.maxTimeInterval else { return }
            strongSelf.unsafeLastSampleDate = Date()
            result = true
        }
        
        return result
    }
    
    public func callAsFunction() -> Bool {
        trySample()
    }
}
