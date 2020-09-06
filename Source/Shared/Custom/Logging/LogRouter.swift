//
//  LogRouter.swift
//

/// by default, Four20 will use its own internal console logger. if you want to change this,
/// set `LogRouter.shared.logger` to your own logging class that implements the `Logger` protocol
public final class LogRouter {
    public var logger: Logger = DefaultLogger()
    public static let shared = LogRouter()
    private init() {}
}
