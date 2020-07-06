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

import ARKit

public extension ARCamera.TrackingState {
    var ft_description: String {
        switch self {
        case .normal:
            return "Normal"
        case .notAvailable:
            return "Not available"
        case .limited(let reason):
            return "Limited (\(reason.ft_description.lowercased()))"
        }
    }
    
    var ft_isNormal: Bool {
        switch self {
        case .normal:
            return true
        default:
            return false
        }
    }
}

public extension ARCamera.TrackingState.Reason {
    var ft_description: String {
        switch self {
        case .excessiveMotion:
            return "Excessive motion"
        case .initializing:
            return "Initializing"
        case .insufficientFeatures:
            return "Insufficient features"
        case .relocalizing:
            return "Relocalizing"
        @unknown default:
            return "Unknown"
        }
    }
}
