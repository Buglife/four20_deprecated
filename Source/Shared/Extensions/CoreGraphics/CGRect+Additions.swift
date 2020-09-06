//
//  CGRect+Additions.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import CoreGraphics

public extension CGRect {
    static func *(lhs: CGRect, rhs: CGSize) -> CGRect {
        let scaleX = rhs.width
        let scaleY = lhs.height
        let x = lhs.minX * scaleX
        let y = lhs.minY * scaleY
        let width = lhs.width * scaleX
        let height = lhs.height * scaleY
        return .init(x: x, y: y, width: width, height: height)
    }
    
    static func *(lhs: CGSize, rhs: CGRect) -> CGRect {
        rhs * lhs
    }
    
    /// keeps the same center
    func ft_withSizeScaled(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return ft_centered(width: newWidth, height: newHeight)
    }
    
    var ft_expandedToSquare: CGRect {
        let longSide = max(width, height)
        return ft_centered(width: longSide, height: longSide)
    }
    
    /// returns a CGRect with the same center, but new width and height
    func ft_centered(width newWidth: CGFloat, height newHeight: CGFloat) -> CGRect {
        let x = self.minX - ((newWidth - width) / 2.0)
        let y = self.minY - ((newHeight - height) / 2.0)
        return .init(x: x, y: y, width: newWidth, height: newHeight)
    }
}
