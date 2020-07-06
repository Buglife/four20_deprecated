//
//  JSONEncoder+Additions
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public extension JSONEncoder {
    static func ft_safeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.nonConformingFloatEncodingStrategy = .ft_convertToString
        return encoder
    }
    
    /// by default, rails apps use IOS 8601 for date encoding,
    /// and snake_case JSON keys
    static func ft_safeRailsEncoder() -> JSONEncoder {
        let encoder = ft_safeEncoder()
        encoder.dateEncodingStrategy = .ft_iso8601Full
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    func ft_encode<T: Encodable>(_ value: T) -> Result<Data, JSONError> {
        do {
            let result = try encode(value)
            return .success(result)
        } catch {
            if let encodingError = error as? EncodingError {
                return .failure(.encodingError(encodingError))
            } else {
                return .failure(.miscellaneous(error))
            }
        }
    }
}

public extension Data {
    func ft_decodedJSON<T: Decodable>() -> Result<T, JSONError> {
        let decoder = JSONDecoder.ft_safeDecoder()
        return decoder.ft_decode(self)
    }
}
