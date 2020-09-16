//
//  QueueBenchmark.swift
//  Copyright © 2019 Observant. All rights reserved.
//

// A little tool for benchmarking performance of operations
// inside an NSOperationQueue, with the assumption that some
// operations may be cancelled.
public final class QueueBenchmark {
    // MARK: - Type definitions
    
    public typealias GetResultsHandler = (Results?) -> ()
    
    public struct Results: CustomDebugStringConvertible {
        let completionPerAdditionRate: Double // returns a % of jobs completed per addition
        let completionPerSecondRate: Double // returns a value in jobs/sec completed
        
        fileprivate init(_ add: Double, sec: Double) {
            completionPerAdditionRate = add
            completionPerSecondRate = sec
        }
        
        public var debugDescription: String {
            return "\(completionPerAdditionRate.ft_2) completions/addition, \(completionPerSecondRate.ft_2) completions/sec"
        }
    }
    
    // MARK: - Instance properties
    
    private let name: String
    private var addCount = 0
    private var completionCount = 0
    private var startTime = CFAbsoluteTimeGetCurrent()
    private let readWriteQueue: DispatchQueue
    
    public init(_ name: String) {
        self.name = name
        self.readWriteQueue = DispatchQueue(label: "QueueBenchmark.readWriteQueue.\(name)")
    }
    
    public func added() {
        readWriteQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._unsafeResetIfNeeded()
            strongSelf.addCount += 1
        }
    }
    
    public func completed() {
        readWriteQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.completionCount += 1
        }
    }
    
    public func getResults(toQueue: DispatchQueue, _ handler: @escaping GetResultsHandler) {
        readWriteQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let results = strongSelf.unsafeResults
            toQueue.async {
                handler(results)
            }
        }
    }
    
    public func log() {
        let name = self.name
        getResults(toQueue: .ft_utility) { results in
            guard let results = results else { return }
            print("• Benchmark \"\(name)\": \(results)")
        }
    }
    
    private var unsafeResults: Results? {
        guard addCount > 0 else { return nil }
        let now = CFAbsoluteTimeGetCurrent()
        let elapsed = now - startTime
        let secRate = Double(completionCount) / elapsed
        let addRate = Double(completionCount) / Double(addCount)
        return Results(addRate, sec: secRate)
    }
    
    private func _unsafeResetIfNeeded() {
        // `1000` is kinda arbitrary, and part of the reason it's there
        // is to prevent integer overflow when the app is running forever
        if addCount > 100 {
            addCount = 0
            completionCount = 0
            startTime = CFAbsoluteTimeGetCurrent()
        }
    }
}
