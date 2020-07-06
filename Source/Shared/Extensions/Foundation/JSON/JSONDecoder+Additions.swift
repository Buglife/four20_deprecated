//
//  JSONDecoder+Additions
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    static func ft_safeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .ft_convertFromString
        return decoder
    }
    
    /// by default, rails apps use IOS 8601 for date encoding,
    /// and snake_case JSON keys
    static func ft_safeRailsDecoder() -> JSONDecoder {
        let decoder = ft_safeDecoder()
        decoder.dateDecodingStrategy = .ft_iso8601Full
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func ft_decode<T: Decodable>(_ data: Data) -> Result<T, JSONError> {
        do {
            let result = try decode(T.self, from: data)
            return .success(result)
        } catch {
            if let decodingError = error as? DecodingError {
                return .failure(.decodingError(decodingError))
            } else {
                return .failure(.miscellaneous(error))
            }
        }
    }
    
    func ft_decode<T: Decodable>(_ jsonDictionary: JSONDictionary) -> Result<T, JSONError> {
        switch jsonDictionary.ft_dataResult {
        case .failure(let error):
            return .failure(error)
        case .success(let data):
            return ft_decode(data)
        }
    }
    
    func ft_decode<T: Decodable>(_ jsonArray: JSONArray) -> Result<T, JSONError> {
        switch jsonArray.ft_dataResult {
        case .failure(let error):
            return .failure(error)
        case .success(let data):
            return ft_decode(data)
        }
    }
}
