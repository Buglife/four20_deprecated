//
//  SIMD4+Float+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import SceneKit

public extension SIMD4 where Scalar == Float {
    init(_ vector: SCNVector4) {
        self.init(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
    }
    
    init(_ vector: SCNVector3) {
        self.init(Float(vector.x), Float(vector.y), Float(vector.z), 1)
    }
}
