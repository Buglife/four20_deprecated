//
//  Result+Additions.swift
//  Four20
//

public extension Result {
    var isSuccessful: Bool {
        switch self {
        case .success(_): return true
        case .failure(_): return false
        }
    }
    
    var isFailure: Bool { !isSuccessful }
}
