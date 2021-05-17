//
//  ErrorForwarder.swift
//

public typealias ErrorUserInfo = [AnyHashable : Any]

/// Enables Four20 internal classes, as well as consumers of Four20, to report errors and let
/// an app's main module define the shared error reporting behavior.
///
/// Your app should set the `errorHandler` property on launch (unless you want to simply use `DefaultErrorHandler`).
public final class ErrorForwarder {
    
    // MARK: - iVars
    
    var errorHandler: ErrorHandler = DefaultErrorHandler()
    
    // MARK: - Initializer
    
    static let shared = ErrorForwarder()
    private init() {}
    
    // MARK: - Public methods
    
    func reportError(_ message: String, underlyingError: Swift.Error?, userInfo: ErrorUserInfo, file: StaticString, function: StaticString, line: UInt) {
        errorHandler.reportError(message, underlyingError: underlyingError, userInfo: userInfo, file: file, function: function, line: line)
    }
    
    func assertionFailure(_ message: String, underlyingError: Swift.Error? = nil, userInfo: ErrorUserInfo = [:], file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        errorHandler.assertionFailure(message, underlyingError: underlyingError, userInfo: userInfo, file: file, function: function, line: line)
    }
}

