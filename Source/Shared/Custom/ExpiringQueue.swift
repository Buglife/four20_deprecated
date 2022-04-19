//
//  Queue.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

/// A queue where elements are automatically dropped after a certain duration, defined by `maxAge`.
/// - Warning: this class depends on the current time, and thus is unsuitable for testing. Consider using `TimeSeriesQueue` instead.
public class ExpiringQueue<T> {
    
    // MARK: - iVars
    
    /// here, the `unfiltered` prefix indicates that these values have *not* been filtered by timestamp yet,
    /// and may contain expired values.
    fileprivate var unfilteredTimestampedValues = [TimestampedValue<T>]()
    public let maxAge: TimeInterval
    
    // MARK: - Initializer
    
    public init(maxAge: TimeInterval) {
        self.maxAge = maxAge
    }
    
    // MARK: - Accessors
    
    public var values: [T] { filteredValues }
    public var timestampedValues: [TimestampedValue<T>] { filteredTimestampedValues }
    public var front: T? { filteredValues.first }
    public var first: T? { front }
    public var frontTimestamped: TimestampedValue<T>? { timestampedValues.first }
    public var firstTimestamped: TimestampedValue<T>? { frontTimestamped }
    
    /// This getter is deprecated, as the value returned from it is not guaranteed to be correct due to its use of `unfilteredTimestampedValues`.
    /// Consider using `TimeSeriesQueue` instead.
    @available(*, deprecated, message: "The value returned by this is not guaranteed to be correct")
    public var count: Int { unfilteredTimestampedValues.count }
    
    /// This getter is deprecated, as the value returned from it is not guaranteed to be correct due to its use of `unfilteredTimestampedValues`.
    /// Consider using `TimeSeriesQueue` instead.
    @available(*, deprecated, message: "The value returned by this is not guaranteed to be correct")
    public var isEmpty: Bool { unfilteredTimestampedValues.isEmpty }
    
    // MARK: - Everything else
    
    /// - Warning: enqueued timestamps are expected to be in ascending order. Calling this method with a timestamp that is earlier than that of a previously enqueued element will result in unexpected behavior. See `_removeExpiredElements()`.
    public func enqueue(_ element: T, timestamp: Date = Date()) {
        guard _canEnqueueElementWithTimestamp(timestamp) else {
            // simple debug assertion here is fine, since this queue gets used heavily & continuously
            assertionFailure()
            return
        }
        unfilteredTimestampedValues.append(.init(element, timestamp: timestamp))
    }
    
    private func _canEnqueueElementWithTimestamp(_ newTimestamp: Date) -> Bool {
        guard let lastTimestamp = unfilteredTimestampedValues.last?.timestamp else {
            return true
        }
        
        return newTimestamp > lastTimestamp
    }
    
    public func dequeue() -> T? {
        _removeExpiredElements()
        if unfilteredTimestampedValues.isEmpty {
            return nil
        } else {
            return unfilteredTimestampedValues.removeFirst().value
        }
    }

    public func removeAll() {
        unfilteredTimestampedValues.removeAll()
    }
    
    private func _removeExpiredElements() {
        // assumes that the unfilteredTimestampedValues are in chronological order (ascending).
        
        // 1. get the index of the last ("youngest") TimestampedValue that is expired
        guard let index = unfilteredTimestampedValues.lastIndex(where: { abs($0.timestamp.timeIntervalSinceNow) > maxAge }) else {
            return
        }
        
        // 2. remove all TimestampedValues up to that point
        unfilteredTimestampedValues.removeSubrange(...index)
    }
    
    private var filteredTimestampedValues: [TimestampedValue<T>] {
        _removeExpiredElements()
        return unfilteredTimestampedValues
    }
    
    private var filteredValues: [T]  {
        filteredTimestampedValues.map(\.value)
    }
    
    public var progress: GenericProgress<TimeInterval> {
        let elapsed = timestampedValues.first?.timestamp.timeIntervalSinceNow.ft_abs ?? 0
        return .init(completed: elapsed, total: maxAge)
    }
    
    // MARK: - Debugging
    
    public func debug_backfill() {
        // we need to backfill with evenly-spaced values;
        // if we simply add one value to the very front of the queue,
        // it'll immediately expire, and the queue will no longer be "full"
        let interval: TimeInterval = 0.1
        let timestampedValues = self.timestampedValues
        guard let last = timestampedValues.last else { return }
//        let lastAge = last.timestamp.timeIntervalSinceNow.ft_abs
//        let timeToBackfill = lastAge - maxAge
        var ts: Date = Date(timeIntervalSinceNow: -maxAge)
        var earlierTimestampedValues = [TimestampedValue<T>]()
        
        while ts < last.timestamp {
            let timestampedValue: TimestampedValue<T> = .init(last.value, at: ts)
            earlierTimestampedValues.append(timestampedValue)
            ts = ts + interval
            
            // extra safety measure in case you're changing code in this
            // method. for some reason, getting into an infinite loop
            // here can *really* fuck up an iPhone
            assert(ts > Date(timeIntervalSinceNow: -(60 * 60 * 24)))
        }
        
        let allTimestampedValues = earlierTimestampedValues + timestampedValues
        self.unfilteredTimestampedValues = allTimestampedValues
    }
}
