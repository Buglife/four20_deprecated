//
//  AtomicArray.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

/// While `Atom` can accomplish this via its `asyncMutate` method, this makes managing an atomic array much easier
public final class AtomicArray<Element>: ExpressibleByArrayLiteral {
    
    // MARK: - iVars
    
    fileprivate var unsafeValues: [Element]
    private let readWriteQueue = DispatchQueue(label: "readWriteQueue", attributes: .concurrent)
    
    // MARK: - Initializer
    
    public init(_ values: [Element] = []) {
        self.unsafeValues = values
    }
    
    public convenience init(arrayLiteral: Element...) {
        self.init(arrayLiteral)
    }
    
    // MARK: - Public methods
    
    /// synchronously returns the values in the array
    public var values: [Element] { _syncGetValues() }
    public var count: Int { values.count }
    
    // MARK: - Appending
    
    public static func +=<Element>(lhs: AtomicArray<Element>, rhs: Element) {
        lhs.syncAppend(contentsOf: [rhs])
    }
    
    public static func +=<S>(lhs: AtomicArray<Element>, rhs: S) where Element == S.Element, S : Sequence {
        lhs.syncAppend(contentsOf: rhs)
    }
    
    public func asyncAppend(_ newElement: Element) {
        _append(async: true, contentsOf: [newElement])
    }
    
    public func syncAppend(_ newElement: Element) {
        _append(async: false, contentsOf: [newElement])
    }
    
    public func asyncAppend<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {
        _append(async: true, contentsOf: newElements)
    }
    
    public func syncAppend<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {
        _append(async: false, contentsOf: newElements)
    }
    
    // MARK: - Removing
    
    public func asyncRemoveAll(where shouldBeRemoved: @escaping (Element) -> Bool) {
        readWriteQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.unsafeValues.removeAll(where: shouldBeRemoved)
        }
    }
    
    @discardableResult
    public func syncRemoveAll(where shouldBeRemoved: @escaping (Element) -> Bool) -> [Element] {
        return readWriteQueue.ft_barrierSync { [weak self] in
            guard let self = self else { return [] }
            var removed: [Element] = []
            var kept: [Element] = []
            for element in self.unsafeValues {
                if shouldBeRemoved(element) {
                    removed.append(element)
                } else {
                    kept.append(element)
                }
            }
            self.unsafeValues = kept
            return removed
        }
    }
    
    @discardableResult
    public func syncRemoveAll() -> [Element] {
        return readWriteQueue.ft_barrierSync { [weak self] in
            guard let self = self else { return [] }
            let oldValuescontents = self.unsafeValues
            self.unsafeValues = []
            return oldValuescontents
        }
    }
    
    public func asyncGetValues(to queue: DispatchQueue = .ft_utility, completion: @escaping ([Element]) -> ()) {
        readWriteQueue.ft_barrierAsync { [weak self] in
            guard let strongSelf = self else { return }
            let values = strongSelf.unsafeValues
            queue.async {
                completion(values)
            }
        }
    }
    
    // MARK: - Inserting
    
    public func asyncInsert(_ newElement: Element, at index: Int) {
        _insert(async: true, newElement: newElement, at: index)
    }
    
    public func syncInsert(_ newElement: Element, at index: Int) {
        _insert(async: false, newElement: newElement, at: index)
    }
    
    // MARK: - Getting / popping
    
    public func syncPopLast() -> Element? {
        return readWriteQueue.ft_barrierSync { [weak self] in
            guard let strongSelf = self else { return nil }
            return strongSelf.unsafeValues.popLast()
        }
    }
    
    // MARK: - Private methods
    
    private func _append<S>(async: Bool, contentsOf newElements: S) where Element == S.Element, S : Sequence {
        _mutate(async: async) { elements in
            elements.append(contentsOf: newElements)
        }
    }
    
    private func _insert(async: Bool, newElement: Element, at index: Int) {
        _mutate(async: async) { elements in
            elements.insert(newElement, at: index)
        }
    }
    
    private func _syncGetValues() -> [Element] {
        var res: [Element]!
        
        readWriteQueue.sync { [weak self] in
            guard let strongSelf = self else { return }
            res = strongSelf.unsafeValues
        }
        
        return res
    }
    
    private func _syncSetValues(_ vals: [Element]) {
        readWriteQueue.sync(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.unsafeValues = vals
        }
    }
    
    public func syncMutate(mutationHandler: @escaping (inout [Element]) -> ()) {
        _mutate(async: false, mutationHandler: mutationHandler)
    }
    
    private func _mutate(async: Bool, mutationHandler: @escaping (inout [Element]) -> ()) {
        readWriteQueue.ft_barrier(async: async) { [weak self] in
            guard let strongSelf = self else { return }
            mutationHandler(&strongSelf.unsafeValues)
        }
    }
}

// MARK: - AtomicArray<Element>

/// Support for initializing empty array Atomics without
/// providing any initialization parameters.
public protocol AtomicArray_ArrayType: ExpressibleByArrayLiteral {
    /// this associated type name needs to be different from the one defined in `Atom_ArrayType`,
    /// otherwise we get a compiler error in release builds (not sure why it doesn't happen in debug builds)
    associatedtype AtomicArray_ElementType
    var ft_atomicArray_asArray: Array<AtomicArray_ElementType> { get }
}
extension Array: AtomicArray_ArrayType {
    public var ft_atomicArray_asArray: Array<Element> { return self }
}
public extension Atomic where Value: AtomicArray_ArrayType {
    convenience init() { self.init([]) }
}
