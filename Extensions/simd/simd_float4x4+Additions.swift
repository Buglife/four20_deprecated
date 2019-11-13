//
//  simd_float4x4+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import simd
import SceneKit

public extension simd_float4x4 {
    init(_ matrix: SCNMatrix4) {
        self.init([
            SIMD4<Float>(matrix.m11, matrix.m12, matrix.m13, matrix.m14),
            SIMD4<Float>(matrix.m21, matrix.m22, matrix.m23, matrix.m24),
            SIMD4<Float>(matrix.m31, matrix.m32, matrix.m33, matrix.m34),
            SIMD4<Float>(matrix.m41, matrix.m42, matrix.m43, matrix.m44)
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
