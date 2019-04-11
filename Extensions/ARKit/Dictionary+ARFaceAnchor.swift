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

import UIKit
import ARKit

public extension Dictionary where Key == ARFaceAnchor.BlendShapeLocation, Value == NSNumber {
    /**
     * Returns a "swifty" dictionary, where there are Doubles
     * as values rather than NSNumbers
     */
    var ft_swifty: [ARFaceAnchor.BlendShapeLocation : Double] {
        return mapValues { $0.doubleValue }
    }
}

public extension Dictionary where Key == ARFaceAnchor.BlendShapeLocation, Value == Double {
    
    // MARK: Shorthand
    
    var ft_eyeBlinkLeft: Double? { return self[.eyeBlinkLeft] }
    var ft_eyeBlinkRight: Double? { return self[.eyeBlinkRight] }
    var ft_eyeSquintLeft: Double? { return self[.eyeSquintLeft] }
    var ft_eyeSquintRight: Double? { return self[.eyeSquintRight] }
    
    // MARK: Computed blend shapes

    var ft_eyeSquintAverage: Double? {
        return [ft_eyeSquintLeft, ft_eyeSquintRight].compactMap({ $0 }).ft_average
    }
}
