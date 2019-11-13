//
//  Result+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

extension Result where Success == Data {
    typealias Completion = (Result<URLSession.HeadersAndJSONObject, URLSession.Error>) -> ()
    
    /// Convenience method for mapping a Result<Data, _> type to a network request,
    /// and immediately performing that request.
    ///
    /// `completion` is dispatched to URLSession's delegateQueue.
    func ft_jsonTask(with url: URL, method: URLSession.Method = .get, headers: [String : String]? = nil, completion: @escaping Completion) {
        switch self {
        case .failure(let error):
            _dispatch(completion, error: .miscellaneous(error))
        case .success(let value):
            guard let task = URLSession.shared.ft_jsonTask(with: url, method: method, headers: headers, body: value, completion: completion) else {
                _dispatch(completion, error: .customMessage("nil URLSessionTask returned"))
                return
            }
            
            task.resume()
        }
    }
    
    private func _dispatch(_ completion: @escaping Completion, error: URLSession.Error) {
        URLSession.shared.delegateQueue.addOperation {
            completion(.failure(error))
        }
    }
}
