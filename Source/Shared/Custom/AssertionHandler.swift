//
//  AssertionHandler.swift
//

public func ft_assertionFailure(_ message: @autoclosure () -> String = String(), underlyingError: Swift.Error? = nil, file: StaticString = #file, line: UInt = #line) {
    AssertionHandler.shared.assertionFailure(message(), underlyingError: underlyingError, file: file, line: line)
}

public func ft_assertMainThread(file: StaticString = #file, line: UInt = #line) {
    AssertionHandler.shared.assert(Thread.isMainThread, file: file, line: line)
}

public func ft_assertBackgroundThread(file: StaticString = #file, line: UInt = #line) {
    AssertionHandler.shared.assert(!Thread.isMainThread, file: file, line: line)
}

public class AssertionHandler {
    static let shared = AssertionHandler()
    private init() {}
    
    func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
        Swift.assert(condition(), message())
    }
    
    func assertionFailure(_ message: @autoclosure () -> String = String(), underlyingError: Swift.Error? = nil, file: StaticString = #file, line: UInt = #line) {
        Swift.assertionFailure(message(), file: file, line: line)
    }
}
