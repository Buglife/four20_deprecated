//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import UIKit

@propertyWrapper
public class Atomic<Value> {
    
    // MARK: Type definitions
    
    typealias GetValueCompletion = (Value) -> ()
    
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
    func asyncGetValue(toQueue: DispatchQueue = .main, completion: @escaping GetValueCompletion) {
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
    func asyncSetValue(_ val: Value) {
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
    
    func syncMutate(_ mutationHandler: @escaping (inout Value) -> ()) {
        readWriteQueue.sync(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            mutationHandler(&strongSelf.unsafeValue)
        }
    }
    
    func asyncMutate(_ mutationHandler: @escaping (inout Value) -> ()) {
        readWriteQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            mutationHandler(&strongSelf.unsafeValue)
        }
    }
}
