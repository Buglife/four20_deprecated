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
import SceneKit

extension SCNVector3: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

public extension SCNVector3 {
    // WARNING: I haven't actually verified that this works,
    //          it was pretty late
    func ft_angleFrom(_ vectorB: SCNVector3) -> SCNFloat {
        //cos(angle) = (A.B)/(|A||B|)
        let cosineAngle = (ft_dotProduct(vectorB) / (ft_magnitude * vectorB.ft_magnitude))
        return SCNFloat(acos(cosineAngle))
    }
    
    func ft_dotProduct(_ vectorB: SCNVector3) -> SCNFloat {
        return (x * vectorB.x) + (y * vectorB.y) + (z * vectorB.z)
    }
    
    /// Calculate the magnitude of this vector
    var ft_magnitude: SCNFloat {
        get {
            return sqrt(ft_dotProduct(self))
        }
    }
}

extension SCNVector3: Equatable {
    public static var zero: SCNVector3 {
        return SCNVector3Zero
    }
    
    
    public init(ft_m m: matrix_float4x4) {
        self.init(m.columns.3.x, m.columns.3.y, m.columns.3.z)
    }
}

public func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}


public func min(_ l: SCNVector3, _ r: SCNVector3) -> SCNVector3 {
    let ld3 = SIMD3<Double>(l)
    let rd3 = SIMD3<Double>(r)
    
    return SCNVector3(min(ld3, rd3))
}

public func max(_ l: SCNVector3, _ r: SCNVector3) -> SCNVector3 {
    let ld3 = SIMD3<Double>(l)
    let rd3 = SIMD3<Double>(r)
    
    return SCNVector3(max(ld3, rd3))
}

#if !os(macOS)
public extension SCNVector3 {
    init(_ vector: SIMD4<Float>) {
        self.init(x: vector.x / vector.w, y: vector.y / vector.w, z: vector.z / vector.w)
    }
    
    func cgPoint(adjustScaleFactor: Bool = false) -> CGPoint {
        if adjustScaleFactor {
            let scale = UIScreen.main.scale
            return CGPoint(x: CGFloat(x) / scale, y: CGFloat(y) / scale)
        }
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

public func * (left: SCNMatrix4, right: SCNVector3) -> SCNVector3 {
    let matrix = float4x4(left)
    let vector = SIMD4<Float>(right)
    let result = matrix * vector
    
    return SCNVector3(result)
}
#endif
