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

public extension URL {
    var ft_creationDate: Date? {
        return ft_attributes?[.creationDate] as? Date
    }
    
    var ft_fileSize: UInt64? {
        return ft_attributes?[.size] as? UInt64
    }
    
    var ft_fileSizeString: String? {
        guard let fileSize = ft_fileSize else { return nil }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB, .useBytes]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(fileSize))
    }
    
    var ft_attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: self.path)
        } catch {
            return nil
        }
    }
    
    // this method is specifically for appending a path to a *hostname*, along with optional query parameters.
    func ft_appendingPath(_ path: String, queryParameters: [String : String]? = nil) -> URL? {
        assert(path.starts(with: "/"))
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            assertionFailure("urlComponents is nil")
            return nil
        }
        urlComponents.path = path
        if let params = queryParameters {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents.url
    }
}
