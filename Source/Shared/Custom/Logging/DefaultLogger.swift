//
//  DefaultLogger.swift
//

public final class DefaultLogger: Logger {
    enum Level {
        case debug
        case info
        case warning
        case error
        
        var emoji: String {
            switch self {
            case .debug: return " "
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "☠️"
            }
        }
    }
    
    public func logDebug(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        _log(.debug, message(), file: file, function: function, line: line)
    }
    
    public func logInfo(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        _log(.info, message(), file: file, function: function, line: line)
    }
    
    public func logWarning(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        _log(.warning, message(), file: file, function: function, line: line)
    }
    
    public func logError(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        _log(.error, message(), file: file, function: function, line: line)
    }
    
    private func _log(_ level: Level, _ message: String, file: StaticString, function: StaticString, line: UInt) {
        let filename = URL(fileURLWithPath: "\(file)").lastPathComponent
        let filenameAndLine = "\(level.emoji) [\(filename):\(line)]"
        print("[420]\(filenameAndLine) \(message)")
    }
}
