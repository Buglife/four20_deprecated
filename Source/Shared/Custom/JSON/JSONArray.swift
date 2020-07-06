//
//  JSONArray
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public typealias JSONArray = [JSONDictionary]

public extension JSONArray {
    var ft_dataResult: Result<Data, JSONError> {
        guard JSONSerialization.isValidJSONObject(self) else {
            return .failure(.invalidObject)
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return .success(data)
        } catch {
            return .failure(.miscellaneous(error))
        }
    }
}
