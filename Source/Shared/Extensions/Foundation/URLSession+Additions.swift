//
//  URLSession+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension URLSession {
    
    // MARK: - Types
    
    typealias Headers = [String : String]
    typealias HeadersAndJSONObject = (headers: Headers, json: JSONObject)
    typealias JSONTaskHandler = (Result<HeadersAndJSONObject, Error>) -> ()
    typealias JSONDictionaryResult = Result<JSONDictionary, Error>
    typealias HeadersAndData = (headers: Headers, data: Data)
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    enum Error: Swift.Error, LocalizedError, BetterDebugStringConvertible {
        case unknown
        case unauthorized // 401
        case urlSession(Swift.Error) // usually implies a connection error
        case jsonEncoding(JSONError) // JSONEncoder errors
        case jsonSerialization(Swift.Error) // JSONSerialization errors
        case jsonTypeMismatch // we expected something else
        case semaphoreNeverSignaled // internal programming error
        case customMessage(String)
        case miscellaneous(Swift.Error)

        // For some reason, for .localizedDescription() to work in an interpolated string,
        // we need to adopt the LocalizedError protocol and implement these:
        public var errorDescription: String? { localizedDescription }
        public var failureReason: String? { localizedDescription }
        
        public var localizedDescription: String {
            switch self {
            case .unknown: return "Unknown error"
            case .unauthorized: return "Unauthorized"
            case .urlSession(let error):
                return "URL session error: \(error.localizedDescription)\n\n(This usually implies a connection error)"
            case .jsonEncoding(let error):
                return "JSON encoding error: \(error.localizedDescription)"
            case .jsonSerialization(let error):
                return "JSON serialization error: \(error.localizedDescription)"
            case .jsonTypeMismatch:
                return "JSON type mismatch"
            case .semaphoreNeverSignaled:
                return "Semaphore never signaled"
            case .customMessage(let message):
                return message
            case .miscellaneous(let error):
                return String(describing: error)
            }
        }
        
        var betterDebugDescription: String { localizedDescription }
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
    
    func ft_postTask<T : Encodable>(with url: URL, body: T, timeoutInterval: TimeInterval? = nil, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask? {
        return ft_jsonTask(with: url, method: .post, encodableBody: body, timeoutInterval: timeoutInterval, completion: completion)
    }
    
    func ft_syncJSONTask<T : Encodable>(with url: URL, method: Method = .get, headers: Headers? = nil, encodableBody: T, timeoutInterval: TimeInterval? = nil) -> Result<HeadersAndJSONObject, Error> {
        ft_assertBackgroundThread()
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<HeadersAndJSONObject, Error> = .failure(.semaphoreNeverSignaled)
        
        let task = ft_jsonTask(with: url, method: method, headers: headers, encodableBody: encodableBody, timeoutInterval: timeoutInterval) { internalResult in
            result = internalResult
            semaphore.signal()
        }
        
        task?.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return result
    }
    
    func ft_jsonTask<T : Encodable>(with url: URL, method: Method = .get, headers: [String : String]? = nil, encodableBody: T, timeoutInterval: TimeInterval? = nil, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask? {
        let encoder = JSONEncoder.ft_safeRailsEncoder()
        
        switch encoder.ft_encode(encodableBody) {
        case .failure(let error):
            completion(.failure(.jsonEncoding(error)))
            return nil
        case .success(let data):
            return ft_jsonTask(with: url, method: method, body: data, timeoutInterval: timeoutInterval, completion: completion)
        }
    }
    
    func ft_postTask(with url: URL, bodyJSON: JSONDictionary, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask? {
        let data: Data
        
        guard JSONSerialization.isValidJSONObject(bodyJSON) else {
            ft_assertionFailure("Error before encoding JSON: bodyJSON probably contains infinities, or NaNs")
            completion(.failure(.jsonTypeMismatch))
            return nil
        }
        do {
            data = try JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        } catch {
            ft_assertionFailure("⚠️ Error encoding JSON: \(error)")
            completion(.failure(.jsonSerialization(error)))
            return nil
        }
        
        return ft_jsonTask(with: url, method: .post, body: data, completion: completion)
    }
    
    func ft_downloadTask(with url: URL, completion: @escaping (Result<URL, Error>) -> ()) -> URLSessionDownloadTask {
        return downloadTask(with: url) { location, response, error in
            if let location = location {
                completion(.success(location))
            } else if let error = error {
                completion(.failure(.urlSession(error)))
            } else {
                ft_assertionFailure()
                return
            }
        }
    }
    
    // For when you just need a json array
    func ft_jsonArrayTask(with url: URL, method: Method = .get, headers: Headers? = nil, body: Data? = nil, completion: @escaping (Result<JSONArray, Error>) -> ()) -> URLSessionTask? {
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
    
    // MARK: - Fetching JSON dictionaries
    
    // For when you just need a json dictionary
    func ft_jsonDictionaryTask(with url: URL, method: Method = .get, headers: Headers? = nil, body: Data? = nil, completion: @escaping (JSONDictionaryResult) -> ()) -> URLSessionTask {
        return ft_jsonTask(with: url, method: method, headers: headers, body: body) { headersAndJsonObjectResult in
            let result: JSONDictionaryResult = headersAndJsonObjectResult.flatMap { result in
                
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
    
    func ft_syncGetJSONDictionary(with url: URL, method: Method = .get, headers: Headers? = nil, body: Data? = nil) -> JSONDictionaryResult {
        ft_assertBackgroundThread()
        let semaphore = DispatchSemaphore(value: 0)
        var result: JSONDictionaryResult = .failure(.semaphoreNeverSignaled)
        
        let task = ft_jsonDictionaryTask(with: url, method: method, headers: headers, body: body) { internalResult in
            result = internalResult
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return result
    }
    
    // MARK: - Fetching JSON
    
    // For when you need the completion handler to return headers, and the json dictionary or array
    func ft_jsonTask(with url: URL, method: Method = .get, headers: Headers? = nil, body: Data? = nil, timeoutInterval: TimeInterval? = nil, completion: @escaping (Result<HeadersAndJSONObject, Error>) -> ()) -> URLSessionTask {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let timeoutInterval = timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }
        
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
    
    // For when you need the completion handler to return headers, and the json dictionary or array
    func ft_dataTask(with url: URL, method: Method = .get, headers: Headers? = nil, body: Data? = nil, completion: @escaping (Result<HeadersAndData, Error>) -> ()) -> URLSessionTask? {
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
    
    func ft_syncGetData(with request: URLRequest) -> Result<Data, Error> {
        ft_assertBackgroundThread()
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Data, Error> = .failure(.semaphoreNeverSignaled)
        
        let task = ft_dataTask(with: request) { internalResult in
            result = internalResult
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return result
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

public extension URLResponse {
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

extension Result where Failure == URLSession.Error {
    public var ft_isUnauthorized: Bool {
        guard let error = self.failure else { return false }
        return error.isUnauthorized
    }
}

extension URLSession.Error {
    public var isLocalRailsConnectionError: Bool {
        guard case let URLSession.Error.urlSession(error) = self else {
            return false
        }
        
        return error.ft_isLocalRailsConnectionError
    }
}
