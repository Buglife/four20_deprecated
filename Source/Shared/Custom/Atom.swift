//
//  Atom.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

@propertyWrapper
class Atom<Value> {
    typealias GetValueHandler = (Value) -> ()
    
    fileprivate var unsafeValue: Value
    private let readWriteQueue = DispatchQueue(label: "com.observantai.Atom.readWriteQueue", attributes: .concurrent)
    
    init(wrappedValue value: Value) {
        self.unsafeValue = value
    }
    
    var wrappedValue: Value {
        get { _syncGetValue() }
        set { _syncSetValue(newValue) }
    }
    
    func asyncGetValue(to queue: DispatchQueue = .main, _ getValueHandler: @escaping GetValueHandler) {
        readWriteQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let val = strongSelf.unsafeValue
            queue.async {
                getValueHandler(val)
            }
        }
    }
    
    func asyncSetValue(_ newValue: Value) {
        readWriteQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.unsafeValue = newValue
        }
    }
    
    func syncMutate(work: @escaping (inout Value) -> ()) {
        readWriteQueue.ft_barrierSync { [weak self] in
            guard let self = self else { return }
            work(&self.unsafeValue)
        }
    }
    
    func asyncMutate(work: @escaping (inout Value) -> ()) {
        readWriteQueue.ft_barrierAsync { [weak self] in
            guard let self = self else { return }
            work(&self.unsafeValue)
        }
    }
    
    func mutate(async: Bool, work: @escaping (inout Value) -> ()) {
        if async {
            asyncMutate(work: work)
        } else {
            syncMutate(work: work)
        }
    }
    
    private func _syncGetValue() -> Value {
        var res: Value!
        
        readWriteQueue.sync { [weak self] in
            guard let strongSelf = self else { return }
            res = strongSelf.unsafeValue
        }
        
        return res
    }
    
    private func _syncSetValue(_ val: Value) {
        readWriteQueue.sync(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.unsafeValue = val
        }
    }
    
    // MARK: - Other stuff
    
    func syncGetAndSet(_ newValue: Value) -> Value {
        return readWriteQueue.ft_barrierSync {
            let oldValue = self.unsafeValue
            self.unsafeValue = newValue
            return oldValue
        }
    }
}

// MARK: - Atom<Optional>

/// Support for initializing Atomics with Optional values,
/// without specifying `nil` in the initializer.
protocol Atom_OptionalType: ExpressibleByNilLiteral {
    associatedtype WrappedType
    var ft_atom_asOptional: WrappedType? { get }
}
extension Optional: Atom_OptionalType {
    public var ft_atom_asOptional: Wrapped? { self }
}
extension Atom where Value: Atom_OptionalType {
    convenience init() { self.init(wrappedValue: nil) }
}

// MARK: - Atom<Array>

/// Support for initializing empty array Atomics without
/// providing any initialization parameters.
protocol Atom_ArrayType: ExpressibleByArrayLiteral {
    associatedtype ElementType
    var ft_atom_asArray: Array<ElementType> { get }
}
extension Array: Atom_ArrayType {
    var ft_atom_asArray: Array<Element> { return self }
}
extension Atom where Value: Atom_ArrayType {
    convenience init() { self.init(wrappedValue: []) }
}
