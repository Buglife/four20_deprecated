//
//  ErrorHandler.swift
//

public protocol ErrorHandler {
    /// Reports an error to a backend, if available.
    /// - Warning: it is advisable to pass in `StaticString` messages so that bug reporting services can group errors properly
    func reportError(_ message: String, underlyingError: Swift.Error?, userInfo: ErrorUserInfo, file: StaticString, function: StaticString, line: UInt)
    
    /// It is the protocol implementation's responsibility to trigger the actual assertion.
    /// - Warning: it is advisable to pass in `StaticString` messages so that bug reporting services can group errors properly
    func assertionFailure(_ message: String, underlyingError: Swift.Error?, userInfo: ErrorUserInfo, file: StaticString, function: StaticString, line: UInt)
}
