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

extension URLSession {
    typealias JSONDictionary = [String : Any]
    
    enum Error: Swift.Error {
        case unknown
        case urlSession(Swift.Error) // usually implies a connection error
        case jsonSerialization(Swift.Error) // JSONSerialization errors
        case jsonTypeMismatch // we expected something else
    }
    
    func ft_jsonDictionaryTask(with url: URL, completion: @escaping (Result<JSONDictionary, Error>) -> ()) -> URLSessionTask {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            let jsonResult = URLSession._parseJSONResult(fromData: data, urlResponse: urlResponse, error: error)
            let jsonDictResult: Result<JSONDictionary, Error> = jsonResult.flatMap { json in
                if let jsonDict = json as? JSONDictionary {
                    return .success(jsonDict)
                } else {
                    return .failure(.jsonTypeMismatch)
                }
            }
            
            completion(jsonDictResult)
        }
        
        return task
    }
    
    func ft_dataTask(with request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                print("NSURLSession error: \(error)")
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
            print("NSURLSession error: \(error)")
            return .failure(.urlSession(error))
        }
        
        guard let data = data else {
            return .failure(.unknown)
        }
        
        if let urlResponse = urlResponse as? HTTPURLResponse {
            let statusCode = urlResponse.statusCode
            print("Status code: \(statusCode)")
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return .success(jsonObject)
        } catch {
            print("Invalid JSON returned")
            return .failure(.jsonSerialization(error))
        }
    }
}
