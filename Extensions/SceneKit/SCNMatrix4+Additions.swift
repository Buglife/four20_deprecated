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
    
    func ft_translated(_ x: Float, _ y: Float, _ z: Float) -> SCNMatrix4 {
        return SCNMatrix4Translate(self, x, y, z)
    }
    
    // MARK: Scale
    
    func ft_scaled(x: Float = 1, y: Float = 1, z: Float = 1) -> SCNMatrix4 {
        return SCNMatrix4Scale(self, x, y, z)
    }
    
    // MARK: Rotation
    
    func ft_pitched(degrees: Float) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .pitch) }
    func ft_rolled(degrees: Float) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .roll) }
    func ft_yawed(degrees: Float) -> SCNMatrix4 { ft_rotated(degrees: degrees, axis: .yaw) }
    
    func ft_rotated(degrees: Float, axis: RotationAxis) -> SCNMatrix4 {
        let rotation = SCNMatrix4.ft_rotation(degrees: degrees, axis: axis)
        return SCNMatrix4Mult(self, rotation)
    }
    
    static func ft_rotation(radians: Float, axis: RotationAxis) -> SCNMatrix4 {
        let x: Float = (axis == .x ? 1 : 0)
        let y: Float = (axis == .y ? 1 : 0)
        let z: Float = (axis == .z ? 1 : 0)
        return SCNMatrix4MakeRotation(radians, x, y, z)
    }
    
    static func ft_rotation(degrees: Float, axis: RotationAxis) -> SCNMatrix4 {
        return ft_rotation(radians: degrees.ft_degreesToRadians, axis: axis)
    }
}
