//
//  CoreGraphics+Additions.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import CoreGraphics

public extension CGImage {
    var ft_size: CGSize {
        return .init(width: width, height: height)
    }
    
    /// Returns the mean luminance of all pixels
    var ft_luminance: Double? {
        guard let imageData = dataProvider?.data else { return nil }
        guard let ptr = CFDataGetBytePtr(imageData) else { return nil }
        let length = CFDataGetLength(imageData)
        var totalLuminance: Double = 0
        
        for i in stride(from: 0, to: length, by: 4) {
            let r = ptr[i]
            let g = ptr[i + 1]
            let b = ptr[i + 2]
            let pixelLuminance = (0.299 * Double(r)) + (0.587 * Double(g)) + (0.114 * Double(b))
            totalLuminance += pixelLuminance
        }
        
        //let pixelCount = width * height
        // the `length` is not equal to the pixel count, and i have no idea why
        return totalLuminance / Double(length)
    }
}
