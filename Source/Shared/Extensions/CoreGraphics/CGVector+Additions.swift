//
//  CGVector+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension CGVector {
    static func +(lhs: CGVector, rhs: CGSize) -> CGVector {
        let x = lhs.dx + rhs.width
        let y = lhs.dy + rhs.height
        return CGVector(dx: x, dy: y)
    }
    
    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        let x = lhs.dx - rhs.dx
        let y = lhs.dy - rhs.dy
        return CGVector(dx: x, dy: y)
    }
    
    static func -(lhs: CGVector, rhs: CGSize) -> CGVector {
        let x = lhs.dx - rhs.width
        let y = lhs.dy - rhs.height
        return CGVector(dx: x, dy: y)
    }
    
    static func *(lhs: CGVector, rhs: CGSize) -> CGVector {
        let x = lhs.dx * rhs.width
        let y = lhs.dy * rhs.height
        return CGVector(dx: x, dy: y)
    }
    
    static func *(lhs: CGVector, rhs: Float) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
    
    static func /(lhs: CGVector, rhs: Float) -> CGVector {
        return CGVector(dx: lhs.dx / CGFloat(rhs), dy: lhs.dy / CGFloat(rhs))
    }
    
    static func /(lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx / CGFloat(rhs), dy: lhs.dy / CGFloat(rhs))
    }
}

public extension Array where Element == CGVector {
    var ft_average: CGVector? {
        guard
            let dx = map({ $0.dx }).ft_average,
            let dy = map({ $0.dy }).ft_average
            else { return nil }
        
        return CGVector(dx: dx, dy: dy)
    }
    
    var ft_standardDeviation: CGVector? {
        guard
            let dx = map({ $0.dx }).ft_standardDeviation,
            let dy = map({ $0.dy }).ft_standardDeviation
            else { return nil }
        
        return CGVector(dx: dx, dy: dy)
    }
}
