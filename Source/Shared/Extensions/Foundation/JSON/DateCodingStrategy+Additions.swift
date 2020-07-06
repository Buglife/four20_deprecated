//
//  DateCodingStrategy
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

extension JSONEncoder.DateEncodingStrategy {
    static var ft_iso8601Full: Self {
        .formatted(.ft_iso8601Full())
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static var ft_iso8601Full: Self {
        .formatted(.ft_iso8601Full())
    }
}
