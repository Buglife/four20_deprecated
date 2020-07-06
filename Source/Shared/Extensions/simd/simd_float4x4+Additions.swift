//
//  simd_float4x4+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import simd
import SceneKit

public extension simd_float4x4 {
    init(_ matrix: SCNMatrix4) {
        self.init([
            SIMD4<Float>(Float(matrix.m11), Float(matrix.m12), Float(matrix.m13), Float(matrix.m14)),
            SIMD4<Float>(Float(matrix.m21), Float(matrix.m22), Float(matrix.m23), Float(matrix.m24)),
            SIMD4<Float>(Float(matrix.m31), Float(matrix.m32), Float(matrix.m33), Float(matrix.m34)),
            SIMD4<Float>(Float(matrix.m41), Float(matrix.m42), Float(matrix.m43), Float(matrix.m44))
            ])
    }
    
    var ft_eulerAngles: SCNVector3 {
        let node = SCNNode()
        node.simdTransform = self
        return node.eulerAngles
    }
}

extension simd_float4x4: Codable {
    private enum CodingKeys: String, CodingKey {
        case columnA
        case columnB
        case columnC
        case columnD
    }
    
    enum CodingError: Error {
        case decoding(String)
        case encoding(String)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let columnA = try values.decode(simd_float4.self, forKey: .columnA)
        let columnB = try values.decode(simd_float4.self, forKey: .columnB)
        let columnC = try values.decode(simd_float4.self, forKey: .columnC)
        let columnD = try values.decode(simd_float4.self, forKey: .columnD)
        self.init(columnA, columnB, columnC, columnD)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self[0], forKey: CodingKeys.columnA)
        try container.encode(self[1], forKey: CodingKeys.columnB)
        try container.encode(self[2], forKey: CodingKeys.columnC)
        try container.encode(self[3], forKey: CodingKeys.columnD)
    }
}
