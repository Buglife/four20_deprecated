//
//  URLSession.Error
//  
//

import Foundation

public extension URLSession {
    enum Error: Swift.Error, LocalizedError, BetterDebugStringConvertible {
        case unknown
        case unauthorized // 401
        case urlSession(Swift.Error) // usually implies a connection error
        case jsonEncoding(JSONError) // JSONEncoder errors
        case jsonSerialization(Swift.Error) // JSONSerialization errors
        case jsonTypeMismatch // we expected something else
        case semaphoreNeverSignaled // internal programming error
        case customMessage(String)
        case miscellaneous(Swift.Error)
        
        // For some reason, for .localizedDescription() to work in an interpolated string,
        // we need to adopt the LocalizedError protocol and implement these:
        public var errorDescription: String? { localizedDescription }
        public var failureReason: String? { localizedDescription }
        
        public var localizedDescription: String {
            switch self {
            case .unknown: return "Unknown error"
            case .unauthorized: return "Unauthorized"
            case .urlSession(let error):
                return "URL session error: \(error.localizedDescription)\n\n(This usually implies a connection error)"
            case .jsonEncoding(let error):
                return "JSON encoding error: \(error.localizedDescription)"
            case .jsonSerialization(let error):
                return "JSON serialization error: \(error.localizedDescription)"
            case .jsonTypeMismatch:
                return "JSON type mismatch"
            case .semaphoreNeverSignaled:
                return "Semaphore never signaled"
            case .customMessage(let message):
                return message
            case .miscellaneous(let error):
                return String(describing: error)
            }
        }
        
        public var betterDebugDescription: String { localizedDescription }
    }
}
