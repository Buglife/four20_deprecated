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
        // adapted from https://one-week-apps.com/arkit-transform-matrices-quaternions-and-related-conversions/
        // intended to be equivalend to:
        //let node = SCNNode()
        //node.simdTransform = self
        //return node.eulerAngles

        
        //first we get the quaternion from m00...m22
        //see http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
        let qw = sqrt(1 + self.columns.0.x + self.columns.1.y + self.columns.2.z) / 2.0
        let qx = -((self.columns.2.y - self.columns.1.z) / (qw * 4.0)) // divergence from source: multiply qx, qy, and qz by -1 to match SceneKit
        let qy = -((self.columns.0.z - self.columns.2.x) / (qw * 4.0))
        let qz = -((self.columns.1.x - self.columns.0.y) / (qw * 4.0))
        
        //then we deduce euler angles with some cosines
        //see https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
        // roll (x-axis rotation)
        let sinr = +2.0 * (qw * qx + qy * qz)
        let cosr = +1.0 - 2.0 * (qx * qx + qy * qy)
        let roll = atan2(sinr, cosr)

        // pitch (y-axis rotation)
        let sinp = +2.0 * (qw * qy - qz * qx)
        var pitch: Float
        if abs(sinp) >= 1 {
             pitch = copysign(Float.pi / 2, sinp)
        } else {
            pitch = asin(sinp)
        }

        // yaw (z-axis rotation)
        let siny = +2.0 * (qw * qz + qx * qy)
        let cosy = +1.0 - 2.0 * (qy * qy + qz * qz)
        let yaw = atan2(siny, cosy)
        
        let manualEulers = SCNVector3(roll, pitch, yaw) // correct for ARKit/scenekit conventions (vs SCNVector3(pitch, yaw, roll))
        return manualEulers
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
