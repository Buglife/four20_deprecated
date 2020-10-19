//
//  AtomicQueue.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public struct AtomicQueue<Element>: ExpressibleByArrayLiteral {
    
    // MARK: - iVars
    
    private let _array: AtomicArray<Element>
    
    // MARK: - Initializer
    
    public init(_ values: [Element] = []) {
        _array = .init(values)
    }
    
    public init(arrayLiteral: Element...) {
        self.init(arrayLiteral)
    }
    
    // MARK: - Public methods & accessors

    /// synchronously returns the values in the queue
    public var values: [Element] { _array.values }
    
    /// alias for `values`
    public var contents: [Element] { values }
    
    public func asyncGetContents(to queue: DispatchQueue = .ft_utility, handler: @escaping ([Element]) -> ()) {
        _array.asyncGetValues(to: queue, completion: handler)
    }

    public func push(_ newElement: Element) {
        _array.syncInsert(newElement, at: 0)
    }

    public func pop() -> Element? {
        _array.syncPopLast()
    }
    
    public func popAll() -> [Element] {
        _array.syncRemoveAll()
    }
    
    /// pops elements from the queue until the given condition is met
    public func popUntil(_ condition: @escaping (Element) -> Bool) -> Element? {
        var result: Element?
        
        _array.syncMutate { contents in
            while contents.count > 0 {
                guard let candidate = contents.popLast() else { return }
                if condition(candidate) {
                    result = candidate
                    break
                }
            }
        }
        
        return result
    }
}
