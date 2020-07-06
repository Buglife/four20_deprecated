//
//  SCNHitTestResult+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import SceneKit

public extension SCNHitTestResult {
    
//    /**
//     * Assuming a plane, returns a normalized location for the given hit
//     * point, where the returned CGPoint is the coordinate from the top-left
//     * corner.
//     */
//    var ft_location2D: CGPoint {
//        let locationFromCenter = self.localCoordinates
//        let width = node.ft_boundingBoxWidth
//        let height = node.ft_boundingBoxHeight
//        let locationFromTopLeftX = (width / 2.0) + locationFromCenter.x
//        let locationFromTopLeftY = (height / 2.0) - locationFromCenter.y
//        return CGPoint(x: Double(locationFromTopLeftX), y: Double(locationFromTopLeftY))
//    }
//    
//    /**
//     * Assuming a plane, returns a normalized location for the given hit
//     * point. For example, CGVector(dx: 0.25, dy: 0.75) indicates a hit point
//     * that is 25% right & 75% down from the top-left corner.
//     */
//    var ft_normalizedLocation2D: CGVector {
//        let width = CGFloat(node.ft_boundingBoxWidth)
//        let height = CGFloat(node.ft_boundingBoxHeight)
//        let location2D = ft_location2D
//        let normalizedX = location2D.x / width
//        let normalizedY = location2D.y / height
//        return CGVector(dx: Double(normalizedX), dy: Double(normalizedY))
//    }
    
    var ft_localCoordinates2D: CGPoint {
        return CGPoint(x: Double(localCoordinates.x), y: Double(localCoordinates.y))
    }
    
    var ft_normalizedLocalCoordinates2D: CGVector {
        let width = CGFloat(node.ft_boundingBoxWidth)
        let height = CGFloat(node.ft_boundingBoxHeight)
        let coord = ft_localCoordinates2D
        let normalizedX = coord.x / (width / 2.0)
        let normalizedY = coord.y / (height / 2.0)
        return CGVector(dx: Double(normalizedX), dy: Double(normalizedY))
    }
}
