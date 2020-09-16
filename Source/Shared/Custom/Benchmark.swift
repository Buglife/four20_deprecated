//
//  Benchmark.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public final class Benchmark {
    private let samplesPerReset = 10
    private let name: String
    private var sampleCount = 0
    private var resetAt = Date()
    private(set) var rate: Double = 0
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func measure() {
        if sampleCount > samplesPerReset {
            sampleCount = 0
            resetAt = Date()
        }
        
        sampleCount += 1
        
        if sampleCount > (samplesPerReset / 2) {
            let elapsed = abs(resetAt.timeIntervalSinceNow)
            rate = Double(sampleCount) / elapsed
        }
    }
    
    public func log() {
        print("• Benchmark \"\(name)\": \(rate.ft_2) / sec")
    }
}
