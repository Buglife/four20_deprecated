//
//  UIBezierPath+Additions.swift
//

import UIKit

public extension UIBezierPath {
    convenience init(ft_circleWithCenter center: CGPoint, radius: CGFloat) {
        let x = center.x - radius
        let y = center.y - radius
        let width = radius * 2.0
        let height = width
        let rect = CGRect(x: x, y: y, width: width, height: height)
        self.init(ovalIn: rect)
    }
}
