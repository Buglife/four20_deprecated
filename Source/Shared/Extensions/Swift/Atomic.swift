//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//

import Foundation

@propertyWrapper
public class Atomic<Value> {
    
    // MARK: Type definitions
    
    public typealias GetValueCompletion = (Value) -> ()
    
    // MARK: Instance properties
    
    /**
     * The "unsafe" value, which must always be accessed
     * on the readWriteQueue.
     */
    private var unsafeValue: Value
    
    /**
     * We use a concurrent dispatch queue for multiple readers,
     * along with barriers for single-writer.
     */
    private let readWriteQueue = DispatchQueue(label: "readWriteQueue", attributes: .concurrent)
    
    // Mark: Initializers
    
    public init(_ value: Value) {
        self.unsafeValue = value
    }
    
    public init(wrappedValue: Value) {
        self.unsafeValue = wrappedValue
    }
    
    // MARK: Accessors
    
    /**
     * Synchronously gets or sets the current value.
     */
    public var value: Value {
        get { wrappedValue }
        set { wrappedValue = newValue }
    }
    
    public var wrappedValue: Value {
        get { _syncGetValue() }
        set { _syncSetValue(newValue) }
    }
    
    /**
     * Asynchronously gets the current value.
     */
    public func asyncGetValue(toQueue: DispatchQueue = .main, completion: @escaping GetValueCompletion) {
        let strongSelf = self
        
        readWriteQueue.async {
            let val = strongSelf.unsafeValue
            toQueue.async {
                completion(val)
            }
        }
    }
    
    /**
     * Asynchronously sets the current value.
     */
    public func asyncSetValue(_ val: Value) {
        let strongSelf = self
        
        readWriteQueue.async(flags: .barrier) {
            strongSelf.unsafeValue = val
        }
    }
    
    // MARK: Private functions
    
    private func _syncGetValue() -> Value {
        var res: Value!
        let strongSelf = self
        
        readWriteQueue.sync {
            res = strongSelf.unsafeValue
        }
        
        return res
    }
    
    private func _syncSetValue(_ val: Value) {
        let strongSelf = self
        
        readWriteQueue.sync(flags: .barrier) {
            strongSelf.unsafeValue = val
        }
    }
    
    // MARK: - More advanced stuff
    
    public func syncMutate(_ mutationHandler: @escaping (inout Value) -> ()) {
        readWriteQueue.sync(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            mutationHandler(&strongSelf.unsafeValue)
        }
    }
    
    public func asyncMutate(_ mutationHandler: @escaping (inout Value) -> ()) {
        readWriteQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            mutationHandler(&strongSelf.unsafeValue)
        }
    }
}

public extension Atomic where Value == Bool {
    var `true`: Bool {
        return self.value
    }

    var `false`: Bool {
        return !self.value
    }
}


/// 'public' modifier cannot be used with extensions that declare protocol conformances.
/// The following code snippet is left here so you can copy it into your app if needed.

//// MARK: - Atom<Optional>
//
///// Support for initializing Atomics with Optional values,
///// without specifying `nil` in the initializer.
//protocol OptionalType: ExpressibleByNilLiteral {
//    associatedtype WrappedType
//    var asOptional: WrappedType? { get }
//}
//extension Optional: OptionalType {
//    public var asOptional: Wrapped? { self }
//}
//extension Atomic where Value: OptionalType {
//    convenience init() { self.init(nil) }
//}
//
//// MARK: - Atomic<Array>
//
///// Support for initializing empty array Atomics without
///// providing any initialization parameters.
//protocol Atomic_ArrayType: ExpressibleByArrayLiteral {
//    associatedtype ElementType
//    var ft_atomic_asArray: Array<ElementType> { get }
//}
//extension Array: Atomic_ArrayType {
//    var ft_atomic_asArray: Array<Element> { return self }
//}
//extension Atomic where Value: Atomic_ArrayType {
//    convenience init() { self.init([]) }
//}
