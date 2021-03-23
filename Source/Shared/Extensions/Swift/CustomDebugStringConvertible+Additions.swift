//
//  CustomDebugStringConvertible+Additions.swift
//

public extension Optional where Wrapped == CustomDebugStringConvertible {
    /// Useful for logging optional values
    var ft_orNil: String {
        guard let val = self else { return "nil" }
        return val.debugDescription
    }
}
