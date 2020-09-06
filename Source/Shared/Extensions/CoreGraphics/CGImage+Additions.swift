//
//  CoreGraphics+Additions.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import CoreGraphics

public extension CGImage {
    var ft_size: CGSize {
        return .init(width: width, height: height)
    }
}
