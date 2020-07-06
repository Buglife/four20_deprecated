//
//  NonConformingFloatStrategy+Additions
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

private let kCodingStrategyPositiveInfinity = "inf"
private let kCodingStrategyNegativeInfinity = "-inf"
private let kCodingStrategyNaN = "NaN"

extension JSONEncoder.NonConformingFloatEncodingStrategy {
    static var ft_convertToString: Self {
        .convertToString(positiveInfinity: kCodingStrategyPositiveInfinity,
                         negativeInfinity: kCodingStrategyNegativeInfinity,
                        nan: kCodingStrategyNaN)
    }
}

extension JSONDecoder.NonConformingFloatDecodingStrategy {
    static var ft_convertFromString: Self {
        .convertFromString(positiveInfinity: kCodingStrategyPositiveInfinity,
                           negativeInfinity: kCodingStrategyNegativeInfinity,
                           nan: kCodingStrategyNaN)
    }
}
