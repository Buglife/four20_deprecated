//
//  CGRect+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

public extension CGRect {
    static func *(lhs: CGRect, rhs: CGSize) -> CGRect {
        let x = lhs.origin.x * rhs.width
        let y = lhs.origin.y * rhs.height
        let width = lhs.size.width * rhs.width
        let height = lhs.size.height * rhs.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
