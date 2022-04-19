//
//  Error+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Error {
    /// If you run into some insane infinite recursion here, try uncommenting the implementation of `NSError.ft_NSError`.
    /// I ran into a situation where this was infinitely recursing, and I either fixed it by adding `NSError.ft_NSError` (returning `self` uncasted),
    /// or fixed via some other means because I'm no longer able to reproduce it.
    var ft_NSError: NSError {
        return self as NSError
    }
    
    var ft_debugDescription: String {
        if let obj = self as? BetterDebugStringConvertible {
            return obj.betterDebugDescription
        }
        
        let urlInParens: String
        if let urlDebugDescription = ft_failingURL?.ft_debugDescription {
            urlInParens = " (\(urlDebugDescription))"
        } else {
            urlInParens = ""
        }
        
        if ft_isRequestTimeoutError {
            return "ft_isRequestTimeoutError" + urlInParens
        }
        
        if ft_isNetworkConnectionLostError {
            return "ft_isNetworkConnectionLostError" + urlInParens
        }
        
        if ft_isNotConnectedToInternetError {
            return "ft_isNotConnectedToInternetError" + urlInParens
        }
        
        return String(describing: self)
    }
    
    // MARK: NSURLDomain errors
    
    var ft_isLocalRailsConnectionError: Bool { ft_NSError.ft_isLocalRailsConnectionError }
    var ft_isRequestTimeoutError: Bool { ft_NSError.ft_isRequestTimeoutError }
    var ft_isNetworkConnectionLostError: Bool { ft_NSError.ft_isNetworkConnectionLostError }
    var ft_isNotConnectedToInternetError: Bool { ft_NSError.ft_isNotConnectedToInternetError }
    var ft_isCannotParseResponseError: Bool { ft_NSError.ft_isCannotParseResponseError }
    var ft_isDataNotAllowedError: Bool { ft_NSError.ft_isDataNotAllowedError }
    var ft_failingURLString: String? { ft_NSError.ft_failingURLString }
    var ft_failingURL: URL? { ft_NSError.ft_failingURL }
}

public extension Optional where Wrapped == Swift.Error {
    var ft_debugDescription: String {
        return self?.ft_debugDescription ?? "[nil]"
    }
}

public extension NSError {
//    var ft_NSError: NSError {
//        return self
//    }
    
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
    /// I'm not entirely certain what exactly causes this, but it was happening while uploading DriverLogs
    /// to my dev machine through an ngrok tunnel
    var ft_isNetworkConnectionLostError: Bool { ft_isNSURLError && code == NSURLErrorNetworkConnectionLost }
    var ft_isNotConnectedToInternetError: Bool { ft_isNSURLError && code == NSURLErrorNotConnectedToInternet }
    var ft_isCannotParseResponseError: Bool { ft_isNSURLError && code == NSURLErrorCannotParseResponse }
    var ft_isDataNotAllowedError: Bool { ft_isNSURLError && code == NSURLErrorDataNotAllowed }
    var ft_isNSURLError: Bool { domain == NSURLErrorDomain }
    var ft_failingURLString: String? { userInfo[NSURLErrorFailingURLStringErrorKey] as? String }
    var ft_failingURL: URL? {
        guard let urlString = ft_failingURLString else { return nil }
        return URL(string: urlString)
    }
    
    /// Returns `true` if the local rails server isn't running, or needs to be restarted
    var ft_isLocalRailsConnectionError: Bool {
        guard ft_isNSURLError, let failingURLString = ft_failingURLString, failingURLString.starts(with: "http://1") else { return false }
        return ft_isRequestTimeoutError || ft_isCannotConnectToHostError
    }
}

public protocol BetterDebugStringConvertible {
    var betterDebugDescription: String { get }
}
