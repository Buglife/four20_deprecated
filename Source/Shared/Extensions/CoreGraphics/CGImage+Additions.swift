//
//  CoreGraphics+Additions.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import CoreGraphics

public extension CGImage {
    
    enum LuminanceRevision {
        /// Buggy version where we didn't advance the pointer
        case rev1
        /// Same as `rev1`, but with the pointer advancement fixed
        case rev2
        /// Same as `rev2`, but uses BT.709 luma coefficients
        case rev3
    }
    
    var ft_size: CGSize {
        return .init(width: width, height: height)
    }
    
    /// Returns the mean luminance of all pixels
    func ft_luminance(_ revision: LuminanceRevision) -> Double? {
        guard let imageData = dataProvider?.data else { return nil }
        guard var ptr = CFDataGetBytePtr(imageData) else { return nil }
        var totalLuminance: Double = 0
        for _ in 0..<height {
            for i in stride(from: 0, to: width, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                
                let pixelLuminance: Double
                
                switch revision {
                case .rev1, .rev2:
                    pixelLuminance = (0.299 * Double(r)) + (0.587 * Double(g)) + (0.114 * Double(b))
                case .rev3:
                    pixelLuminance = (0.2126 * Double(r)) + (0.7152 * Double(g)) + (0.0722 * Double(b))
                }
                
                totalLuminance += pixelLuminance
            }
            
            if revision != .rev1 {
                ptr = ptr.advanced(by: bytesPerRow)
            }
        }
        return totalLuminance / Double(width * height)
    }
}
