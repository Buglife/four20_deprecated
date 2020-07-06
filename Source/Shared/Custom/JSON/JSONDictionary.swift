//
//  JSONDictionary
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String : Any]

public extension JSONDictionary {
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
    
    var ft_prettyPrinted: String? {
        let data: Data
        
        guard JSONSerialization.isValidJSONObject(self) else {
            print("\(self)\n⚠️⚠️⚠️ The above JSONDictionary isn't valid JSON.")
            return nil
        }
        do {
            data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

