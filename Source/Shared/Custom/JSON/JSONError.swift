//
//  JSONError
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public enum JSONError: Error {
    case invalidObject
    case encodingError(EncodingError)
    case decodingError(DecodingError)
    case miscellaneous(Swift.Error)
}
