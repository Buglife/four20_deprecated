//
//  Sampler.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

public final class IntegerSampler {
    public let maxCount: Int
    private var unsafeCurrentCount = 0
    private let readWriteQueue = DispatchQueue(label: "readWriteQueue")
    
    public init(_ maxCount: Int) {
        self.maxCount = maxCount
    }
    
    public func trySample() -> Bool {
        var result = false
        
        readWriteQueue.sync { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.unsafeCurrentCount += 1
            
            if strongSelf.unsafeCurrentCount > strongSelf.maxCount {
                result = true
                strongSelf.unsafeCurrentCount = 0
            }
        }
        
        return result
    }
    
    public func callAsFunction() -> Bool {
        trySample()
    }
}
