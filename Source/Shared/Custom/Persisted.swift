//
//  Persisted.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

/// Class that holds an object, where the object is read from disk on initialization if it exists,
/// and written to disk in the object setter.
/// The intent here is to be able to define ivars in a class for quick access while persisting those to UserDefaults easily.
///
/// This class replaces `UserDefault`
@propertyWrapper
public final class Persisted<Value: Codable> {

    // MARK: - Statics

    private static func getUserDefaultsKey(suffix: String) -> String {
        "com.observantai.Persisted.\(suffix)"
    }

    // MARK: - iVars

    /// An instance of `Persisted` is initialized with a key such as "Foo.bar",
    /// and the user defaults key becomes "com.observantai.Persisted.Foo.bar"
    private let userDefaultsKeySuffix: String
    private var userDefaultsKey: String { Persisted.getUserDefaultsKey(suffix: userDefaultsKeySuffix) }
    @Atom private var value: Value

    // MARK: - Initializer

    public init(key: String, initialValue valueIfNotInUserDefaults: Value) {
        self.userDefaultsKeySuffix = key

        let userDefaultsKey = Persisted.getUserDefaultsKey(suffix: key)
        if let cachedValue: Value = UserDefaults.standard.ft_wrappedObject(forKey: userDefaultsKey) {
            value = cachedValue
        } else {
            value = valueIfNotInUserDefaults
        }
    }

    public init(wrappedValue value: Value) {
        preconditionFailure("This initializer is not supported")
    }

    public var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            UserDefaults.standard.ft_setWrappedObject(newValue, forKey: userDefaultsKey)
        }
    }

    // MARK: - Sync / async stuff

    public typealias GetValueHandler = (Value) -> ()

    public func asyncGetValue(_ getValueHandler: @escaping GetValueHandler) {
        _value.asyncGetValue(getValueHandler)
    }

    public func syncMutate(_ work: @escaping (inout Value) -> ()) {
        _mutate(async: false, work: work)
    }

    public func asyncMutate(_ work: @escaping (inout Value) -> ()) {
        _mutate(async: true, work: work)
    }

    private func _mutate(async: Bool, work: @escaping (inout Value) -> ()) {
        let userDefaultsKey = self.userDefaultsKeySuffix
        _value.mutate(async: async) { val in
            work(&val)
            UserDefaults.standard.ft_setWrappedObject(val, forKey: userDefaultsKey)
        }
    }
}

fileprivate extension UserDefaults {
    private struct Wrapper<T: Codable>: Codable {
        let key: String
        let value: T
    }

    func ft_wrappedObject<T: Codable>(forKey key: String) -> T? {
        guard let encodedWrapper = data(forKey: key) else { return nil }
        let wrapper: Wrapper<T>

        do {
            wrapper = try JSONDecoder.ft_safeDecoder().decode(Wrapper<T>.self, from: encodedWrapper)
        } catch {
            ft__assertionFailure("Error decoding wrapped object", underlyingError: error)
            return nil
        }

        return wrapper.value
    }

    func ft_setWrappedObject<T: Codable>(_ obj: T?, forKey key: String) {
        guard let obj = obj else {
            removeObject(forKey: key)
            return
        }

        let wrapper: Wrapper<T> = .init(key: key, value: obj)
        let encodedWrapper: Data

        do {
            encodedWrapper = try JSONEncoder.ft_safeEncoder().encode(wrapper)
        } catch {
            ft__assertionFailure("Error encoding wrapped object", underlyingError: error)
            return
        }

        set(encodedWrapper, forKey: key)
    }
}
