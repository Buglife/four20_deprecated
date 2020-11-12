//
//  Queue.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

/// A queue where elements are automatically dropped after a certain duration, defined by `maxAge`.
public class ExpiringQueue<T> {
    /// here, the `unfiltered` prefix indicates that these values have *not* been filtered by timestamp yet,
    /// and may contain expired values.
    fileprivate var unfilteredTimestampedValues = [TimestampedValue<T>]()
    public let maxAge: TimeInterval
    
    public init(maxAge: TimeInterval) {
        self.maxAge = maxAge
    }
    
    public var count: Int { unfilteredTimestampedValues.count }
    
    public var isEmpty: Bool { unfilteredTimestampedValues.isEmpty }
    
    public func enqueue(_ element: T) {
        unfilteredTimestampedValues.append(.init(element))
    }
    
    public func dequeue() -> T? {
        _removeExpiredElements()
        if isEmpty {
            return nil
        } else {
            return unfilteredTimestampedValues.removeFirst().value
        }
    }

    public var values: [T] { filteredValues }
    public var timestampedValues: [TimestampedValue<T>] { filteredTimestampedValues }

    public var front: T? { filteredValues.first }

    public var first: T? { front }
    
    public func removeAll() {
        unfilteredTimestampedValues.removeAll()
    }
    
    private func _removeExpiredElements() {
        unfilteredTimestampedValues.removeAll { abs($0.timestamp.timeIntervalSinceNow) > maxAge }
    }
    
    private var filteredTimestampedValues: [TimestampedValue<T>] {
        _removeExpiredElements()
        return unfilteredTimestampedValues
    }
    
    private var filteredValues: [T]  {
        filteredTimestampedValues.map(\.value)
    }
}
