//
//  Error+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Error {
    var ft_NSError: NSError {
        return self as NSError
    }
    
    var ft_debugDescription: String {
        if let obj = self as? BetterDebugStringConvertible {
            return obj.betterDebugDescription
        }
        
        return String(describing: self)
    }
    
    var ft_isLocalRailsConnectionError: Bool { ft_NSError.ft_isLocalRailsConnectionError }
}

public extension NSError {
    var ft_underlyingError: NSError? {
        return userInfo[NSUnderlyingErrorKey] as? NSError
    }
    
    /**
     * Since we're often trying to connect to localhost
     * during development, and sometimes we're intentionally
     * just not running a local server, this provides an
     * easy way to check if an attempted network request
     * failed due to not finding the host, and if so we
     * don't have to bother logging extensive error details.
     */
    var ft_isCannotConnectToHostError: Bool {
        if let underlyingError = ft_underlyingError, underlyingError.ft_isCannotConnectToHostError {
            return true
        }
        
        let isNSURLError = self.domain == NSURLErrorDomain
        let cannotConnectToHost = self.code == NSURLErrorCannotConnectToHost
        return isNSURLError && cannotConnectToHost
    }
    
    /// This sometimes happens when (a) we're trying to connect to localhost, and
    /// (b) RubyMine or Rails is shitting bricks and the local server needs to be restarted.
    var ft_isRequestTimeoutError: Bool { ft_isNSURLError && code == NSURLErrorTimedOut }
    var ft_isNSURLError: Bool { domain == NSURLErrorDomain }
    var ft_failingURLString: String? { userInfo[NSURLErrorFailingURLStringErrorKey] as? String }
    
    /// Returns `true` if the local rails server isn't running, or needs to be restarted
    var ft_isLocalRailsConnectionError: Bool {
        guard ft_isNSURLError, let failingURLString = ft_failingURLString, failingURLString.starts(with: "http://1") else { return false }
        return ft_isRequestTimeoutError || ft_isCannotConnectToHostError
    }
}

public protocol BetterDebugStringConvertible {
    var betterDebugDescription: String { get }
}
