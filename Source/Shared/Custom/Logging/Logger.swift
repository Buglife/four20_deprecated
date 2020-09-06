//
//  Logger.swift
//

public protocol Logger {
    func logDebug(_ message: @autoclosure () -> String, file: StaticString, function: StaticString, line: UInt)
    func logInfo(_ message: @autoclosure () -> String, file: StaticString, function: StaticString, line: UInt)
    func logWarning(_ message: @autoclosure () -> String, file: StaticString, function: StaticString, line: UInt)
    func logError(_ message: @autoclosure () -> String, file: StaticString, function: StaticString, line: UInt)
}


