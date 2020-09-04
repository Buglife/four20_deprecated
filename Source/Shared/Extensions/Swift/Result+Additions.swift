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

/// sorry folks you're gonna have to just copy+pasta this into your application code because
/// swift doesn't allow public extensions that declare protocol conformances

//public extension Result: Codable where Success: Codable, Failure: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case success
//        case successValue
//        case failure
//        case failureError
//    }
//    
//    enum CodingError: Error {
//        case decoding(String)
//        case encoding(String)
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        if values.contains(.success) {
//            let successValue = try values.decode(Success.self, forKey: .successValue)
//            self = .success(successValue)
//        } else if values.contains(.failure) {
//            let failureError = try values.decode(Failure.self, forKey: .failureError)
//            self = .failure(failureError)
//        } else {
//            throw CodingError.decoding("Error decoding Result")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        switch self {
//        case .success(let value):
//            try container.encode(true, forKey: .success)
//            try container.encode(value, forKey: .successValue)
//        case .failure(let error):
//            try container.encode(true, forKey: .failure)
//            try container.encode(error, forKey: .failureError)
//        }
//    }
//}
