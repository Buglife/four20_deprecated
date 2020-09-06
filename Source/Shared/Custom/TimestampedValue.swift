//
//  TimestampedValue.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public struct TimestampedValue<T> {
    public let timestamp: Date
    public let value: T
    
    public init(_ value: T, at timestamp: Date = Date()) {
        self.timestamp = timestamp
        self.value = value
    }
    
    public func valueIfAfterSecondsAgo(_ seconds: TimeInterval) -> T? {
        let ts = Date(timeIntervalSinceNow: -seconds)
        
        if timestamp > ts {
            return value
        } else {
            return nil
        }
    }
}
