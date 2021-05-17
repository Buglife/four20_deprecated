//
//  DefaultErrorHandler.swift
//

public class DefaultErrorHandler: ErrorHandler {
    public func reportError(_ message: String, underlyingError: Error?, userInfo: ErrorUserInfo, file: StaticString, function: StaticString, line: UInt) {
        LogRouter.shared.logger.logError(message, file: file, function: function, line: line)
    }
    
    public func assertionFailure(_ message: String, underlyingError: Swift.Error?, userInfo: ErrorUserInfo, file: StaticString, function: StaticString, line: UInt) {
        Swift.assertionFailure(message, file: file, line: line)
    }
}
