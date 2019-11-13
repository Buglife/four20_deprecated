//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import Foundation

public typealias JSONDictionary = [String : Any]
public typealias JSONArray = [JSONDictionary]

public extension URLSession {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Error: Swift.Error, LocalizedError {
        case unknown
        case unauthorized // 401
        case urlSession(Swift.Error) // usually implies a connection error
        case jsonSerialization(Swift.Error) // JSONSerialization errors
        case jsonTypeMismatch // we expected something else
        case customMessage(String)
        case miscellaneous(Swift.Error)

        // For some reason, for .localizedDescription() to work in an interpolated string,
        // we need to adopt the LocalizedError protocol and implement these:
        public var errorDescription: String? { localizedDescription }
        public var failureReason: String? { localizedDescription }
        
        var localizedDescription: String {
            switch self {
            case .unknown: return "Unknown error"
            case .unauthorized: return "Unauthorized"
            case .urlSession(let error):
                return "URL session error: \(error.localizedDescription)\n\n(This usually implies a connection error)"
            case .jsonSerialization(let error):
                return "JSON serialization error: \(error.localizedDescription)"
            case .jsonTypeMismatch:
                return "JSON type mismatch"
            case .customMessage(let message):
                return message
            case .miscellaneous(let error):
                return String(describing: error)
            }
        }
    }
    
    enum JSONObject {
        case dictionary(JSONDictionary)
        case array(JSONArray)
        
        init?(_ object: Any) {
            if let dict = object as? JSONDictionary {
                self = .dictionary(dict)
            } else if let arr = object as? JSONArray {
                self = .array(arr)
            } else {
                return nil
            }
        }
    }
    
    typealias HeadersAndJSONObject = (headers: [String : String], json: JSONObject)
    
    func ft_postTask(with url: URL, bodyJSON: JSONDictionary, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask? {
        let data: Data
        
        do {
            data = try JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        } catch {
            print("⚠️ Error encoding JSON: \(error)")
            completion(.failure(.jsonSerialization(error)))
            return nil
        }
        
        return ft_jsonTask(with: url, method: .post, body: data, completion: completion)
    }
    
    // For when you just need a json array
    func ft_jsonArrayTask(with url: URL, method: Method = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping (Result<JSONArray, Error>) -> ()) -> URLSessionTask? {
        return ft_jsonTask(with: url, method: method, headers: headers, body: body) { headersAndJsonObjectResult in
            let result: Result<JSONArray, Error> = headersAndJsonObjectResult.flatMap { result in
                switch result.json {
                case .array(let arr):
                    return .success(arr)
                case .dictionary(_):
                    return .failure(.jsonTypeMismatch)
                }
            }
            completion(result)
        }
    }
    
    // For when you just need a json dictionary
    func ft_jsonDictionaryTask(with url: URL, method: Method = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping (Result<JSONDictionary, Error>) -> ()) -> URLSessionTask? {
        return ft_jsonTask(with: url, method: method, headers: headers, body: body) { headersAndJsonObjectResult in
            let result: Result<JSONDictionary, Error> = headersAndJsonObjectResult.flatMap { result in
                switch result.json {
                case .dictionary(let dict):
                    return .success(dict)
                case .array(_):
                    return .failure(.jsonTypeMismatch)
                }
            }
            completion(result)
        }
    }
    
    // For when you need the completion handler to return headers, and the json dictionary or array
    func ft_jsonTask(with url: URL, method: Method = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { header in
            let (key, value) = header
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            let jsonResult = URLSession._parseJSONResult(fromData: data, urlResponse: urlResponse, error: error)
            let result: Result<HeadersAndJSONObject, Error>
            
            if let httpURLResponse = urlResponse as? HTTPURLResponse, httpURLResponse.statusCode == 401 {
                result = .failure(.unauthorized)
            } else {
                result = jsonResult.flatMap { json in
                    if let jsonObject = JSONObject(json) {
                        let headers = urlResponse?.ft_allHeaderFields ?? [:]
                        let response = (headers: headers, json: jsonObject)
                        return .success(response)
                    } else {
                        return .failure(.jsonTypeMismatch)
                    }
                }
            }
            
            completion(result)
        }
        
        return task
    }
    
    typealias HeadersAndData = (headers: [String : String], data: Data)
    
    // For when you need the completion handler to return headers, and the json dictionary or array
    func ft_dataTask(with url: URL, method: Method = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping (Result<HeadersAndData, Error>) -> ()) -> URLSessionTask? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { header in
            let (key, value) = header
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            let result: Result<HeadersAndData, Error>
            
            if let httpURLResponse = urlResponse as? HTTPURLResponse, httpURLResponse.statusCode == 401 {
                result = .failure(.unauthorized)
            } else if let data = data {
                let headers = urlResponse?.ft_allHeaderFields ?? [:]
                let response = (headers: headers, data: data)
                result = .success(response)
            } else {
                result = .failure(.unknown)
            }
            
            completion(result)
        }
        
        return task
    }
    
    func ft_dataTask(with request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.urlSession(error)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.unknown))
                return
            }
            
            completionHandler(.success(data))
        }
        
        return task
    }
    
    // MARK: - Private methods
    
    private class func _parseJSONResult(fromData data: Data?, urlResponse: URLResponse?, error: Swift.Error?) -> Result<Any, Error> {
        if let error = error {
            return .failure(.urlSession(error))
        }
        
        guard let data = data else {
            return .failure(.unknown)
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return .success(jsonObject)
        } catch {
            return .failure(.jsonSerialization(error))
        }
    }
}

extension URLResponse {
    var ft_allHeaderFields: [String : String]? {
        guard let httpUrlResponse = self as? HTTPURLResponse else { return nil }
        
        var headers: [String : String] = [:]
        
        for header in httpUrlResponse.allHeaderFields {
            if let key = header.key as? String, let val = header.value as? String {
                headers[key] = val
            }
        }
        
        return headers
    }
}

public extension URLSession.Error {
    var isUnauthorized: Bool {
        switch self {
        case .unauthorized: return true
        default: return false
        }
    }
}

public extension Result where Failure == URLSession.Error {
    var ft_isUnauthorized: Bool {
        guard let error = self.failure else { return false }
        return error.isUnauthorized
    }
}

public extension Result {
    var failure: Failure? {
        switch self {
        case .failure(let f): return f
        default: return nil
        }
    }
    var success: Success? {
        switch self {
        case .success(let s): return s
        default: return nil
        }
    }
}
