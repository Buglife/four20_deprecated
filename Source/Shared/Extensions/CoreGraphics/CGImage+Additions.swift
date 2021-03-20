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
        guard var ptr = CFDataGetBytePtr(imageData) else { return nil }
        var totalLuminance: Double = 0
        for _ in 0..<height {
            for i in stride(from: 0, to: width, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                
                /// shit we got off stackoverflow or something at some point
                let pixelLuminance = (0.299 * Double(r)) + (0.587 * Double(g)) + (0.114 * Double(b))
                
                /// BT.709
//                let pixelLuminance = (0.2126 * Double(r)) + (0.7152 * Double(g)) + (0.0722 * Double(b))
                
                totalLuminance += pixelLuminance
            }
            
            ptr = ptr.advanced(by: bytesPerRow)
        }
        return totalLuminance / Double(width * height)
    }
}
