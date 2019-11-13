//
//  CGAffineTransform+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
    /// Returns the rotation in radians
    var ft_rotation: CGFloat { atan2(b, a) }
}
