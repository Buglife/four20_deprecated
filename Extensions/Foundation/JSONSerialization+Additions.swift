//
//  JSONSerialization+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

enum JSONError: Error {
    case encodingError(EncodingError)
    case decodingError(DecodingError)
    case miscellaneous(Swift.Error)
}

extension JSONDictionary {
    var ft_dataResult: Result<Data, JSONError> {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return .success(data)
        } catch {
            return .failure(.miscellaneous(error))
        }
    }
    
    var ft_prettyPrinted: String? {
        let data: Data
        
        do {
            data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

extension JSONEncoder {
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

extension JSONDecoder {
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
}

extension Data {
    func ft_decodedJSON<T: Decodable>() -> Result<T, JSONError> {
        let decoder = JSONDecoder()
        return decoder.ft_decode(self)
    }
}
