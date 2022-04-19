//
//  TimeSeriesQueue.swift
//

import Foundation

/// - Note: `TimeSeriesQueue` is a struct, while `ExpiringQueue` is a class. Take this into consideration when switching from the latter to the former.
public struct TimeSeriesQueue<T> {
    
    // MARK: - iVars
    
    private(set) var timestampedValues = [TimestampedValue<T>]()
    public let maxDuration: TimeInterval
    
    // MARK: - Initializer
    
    public init(maxDuration: TimeInterval) {
        self.maxDuration = maxDuration
    }
    
    // MARK: - Accessors
    
    public var values: [T] {
        timestampedValues.map(\.value)
    }
    
    public var count: Int { timestampedValues.count }
    
    public var isEmpty: Bool { timestampedValues.isEmpty }
    
    // MARK: - Enqueue
    
    mutating public func enqueue(_ element: T, timestamp: Date) {
        guard _canEnqueue(withTimestamp: timestamp) else {
            // simple debug assertion here is fine, since this queue gets used heavily & continuously
            assertionFailure()
            return
        }
        timestampedValues.append(.init(element, timestamp: timestamp))
        _removeExpiredElements()
    }
    
    private func _canEnqueue(withTimestamp newTimestamp: Date) -> Bool {
        guard let lastTimestamp = timestampedValues.last?.timestamp else {
            return true
        }
        
        return newTimestamp > lastTimestamp
    }
    
    // MARK: - Private methods
    
    mutating private func _removeExpiredElements() {
        // assumes that the unfilteredTimestampedValues are in chronological order (ascending).
        
        guard let newestTimestamp = timestampedValues.last?.timestamp else { return }
        
        // we're going to remove all elements older than `cutoffTimestamp`
        let cutoffTimestamp = newestTimestamp - maxDuration
        
        // need at least 2 elements, since we're removing elements that are older than `maxDuration` seconds than the newest element
        guard timestampedValues.count >= 2 else { return }
        
        // get the index of the last ("youngest") TimestampedValue that is expired
        guard let index = timestampedValues.lastIndex(where: { $0.timestamp < cutoffTimestamp }) else {
            return
        }
        
        // remove all TimestampedValues up to that point
        timestampedValues.removeSubrange(...index)
    }
}
