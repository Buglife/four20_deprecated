//
//  AssertionHandler.swift
//

/// - Parameter message: This is a `StaticString` so that errors get grouped properly by bug reporting services
public func ft__assertionFailure(_ message: StaticString? = nil, underlyingError: Swift.Error? = nil, userInfo: ErrorUserInfo = [:], file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let reportedMessage: String
    
    if let message = message {
        reportedMessage = String(describing: message)
    } else {
        reportedMessage = "Assertion failure in \(function)"
    }
    
    ErrorForwarder.shared.assertionFailure(reportedMessage, underlyingError: underlyingError, file: file, function: function, line: line)
}

public func ft__assertMainThread(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    _ft__assertThread(isMain: true)
}

public func ft__assertBackgroundThread(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    _ft__assertThread(isMain: false)
}

fileprivate func _ft__assertThread(isMain: Bool, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    if (isMain && !Thread.isMainThread) || (!isMain && Thread.isMainThread) {
        let prefix: String = isMain ? "Main" : "Background"
        ErrorForwarder.shared.assertionFailure("\(prefix) thread assertion", file: file, function: function, line: line)
    }
}

/// Breaks the debugger, if this is a debug build.
func ft__breakpoint(_ message: StaticString? = nil, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    if let message = message {
        LogRouter.shared.logger.logDebug(String(describing: message), file: file, function: function, line: line)
    }
    
    #if DEBUG
    raise(SIGINT)
    #endif
}

public func ft__unimplemented() -> Never {
    preconditionFailure()
}

/// Use this when you want to generate a compiler warning, i.e. to remind yourself to go back
/// and implement something before committing
@available(*, deprecated, message: "Not yet implemented")
public func ft__unimplementedWarning(_ message: StaticString) -> Never {
    preconditionFailure(String(describing: message))
}
