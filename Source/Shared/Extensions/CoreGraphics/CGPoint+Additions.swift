//
//  CGPoint+Additions.swift
//

import CoreGraphics

public extension CGPoint {
    func ft_distance(from: CGPoint) -> CGFloat {
        sqrt((from.x - self.x) * (from.x - self.x) + (from.y - self.y) * (from.y - self.y))
    }
}

public extension Array where Element == CGPoint {
    func ft_centroid() -> CGPoint? {
        guard let avgX = self.map(\.x).ft_average else { return nil }
        guard let avgY = self.map(\.y).ft_average else { return nil }
        return .init(x: avgX, y: avgY)
    }
    
    /// returns the smallest bounding box containing all of the receiver's points
    var ft_boundingBox: CGRect? {
        var optMinMaxX: (min: CGFloat, max: CGFloat)?
        var optMinMaxY: (min: CGFloat, max: CGFloat)?
        
        for point in self {
            if var minMaxX = optMinMaxX {
                if point.x < minMaxX.min {
                    minMaxX.min = point.x
                } else if point.x > minMaxX.max {
                    minMaxX.max = point.x
                }
                optMinMaxX = minMaxX
            } else {
                optMinMaxX = (min: point.x, max: point.x)
            }

            if var minMaxY = optMinMaxY {
                if point.y < minMaxY.min {
                    minMaxY.min = point.y
                } else if point.y > minMaxY.max {
                    minMaxY.max = point.y
                }
                optMinMaxY = minMaxY
            } else {
                optMinMaxY = (min: point.y, max: point.y)
            }
        }
        
        guard let minMaxX = optMinMaxX, let minMaxY = optMinMaxY else { return nil }
        let width = minMaxX.max - minMaxX.min
        let height = minMaxY.max - minMaxY.min
        return .init(x: minMaxX.min, y: minMaxY.min, width: width, height: height)
    }
}
