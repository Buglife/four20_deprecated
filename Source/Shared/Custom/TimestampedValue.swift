//
//  TimestampedValue.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

public protocol TimestampValued {

    associatedtype ValueType
    var timestamp: Date { get }
    var value: ValueType { get }
}

public struct TimestampedValue<T> : TimestampValued {
    
    typealias T = ValueType
    public let timestamp: Date
    public let value: T
    public var age: TimeInterval { timestamp.timeIntervalSinceNow.ft_abs }
    
    public init(_ value: T, at timestamp: Date) {
        self.init(value, timestamp: timestamp)
    }
    
    public init(_ value: T, timestamp: Date = Date()) {
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

/// You'll need to add this to your app code (if you want)
 extension TimestampedValue: Codable where T: Codable {}
