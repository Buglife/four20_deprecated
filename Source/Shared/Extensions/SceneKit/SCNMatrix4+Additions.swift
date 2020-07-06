import SceneKit

public extension SCNMatrix4 {
    
    // MARK: - Type definitions
    
    enum RotationAxis {
        case x
        case y
        case z
        
        static let pitch = RotationAxis.x
        static let roll = RotationAxis.y
        static let yaw = RotationAxis.z
        
        // MARK: Mnemonics
        
        /**
         * When you "row" a boat, you're rotating around the x axis
         */
        
        static let row = RotationAxis.x
        static let parallelToGravity = RotationAxis.y
    }
    
    // MARK: Shorthand
    
    static let ft_identity = SCNMatrix4Identity
    
    // MARK: Translation
    
    func ft_translated(_ x: FTSKFloat, _ y: FTSKFloat, _ z: FTSKFloat) -> SCNMatrix4 {
        return SCNMatrix4Translate(self, x, y, z)
    }
    
    // MARK: Scale
    
    func ft_scaled(x: FTSKFloat = 1, y: FTSKFloat = 1, z: FTSKFloat = 1) -> SCNMatrix4 {
        return SCNMatrix4Scale(self, x, y, z)
    }
    
    // MARK: Rotation
    
    func ft_pitched(degrees: FTSKFloat) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .pitch) }
    func ft_rolled(degrees: FTSKFloat) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .roll) }
    func ft_yawed(degrees: FTSKFloat) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .yaw) }
    
    func ft_rotated(degrees: FTSKFloat, axis: RotationAxis) -> SCNMatrix4 {
        let rotation = SCNMatrix4.ft_rotation(degrees: degrees, axis: axis)
        return SCNMatrix4Mult(self, rotation)
    }
    
    static func ft_rotation(radians: FTSKFloat, axis: RotationAxis) -> SCNMatrix4 {
        let x: FTSKFloat = (axis == .x ? 1 : 0)
        let y: FTSKFloat = (axis == .y ? 1 : 0)
        let z: FTSKFloat = (axis == .z ? 1 : 0)
        return SCNMatrix4MakeRotation(radians, x, y, z)
    }
    
    static func ft_rotation(degrees: FTSKFloat, axis: RotationAxis) -> SCNMatrix4 {
        return ft_rotation(radians: degrees.ft_degreesToRadians, axis: axis)
    }
}
