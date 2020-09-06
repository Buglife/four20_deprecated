//
//  OBSRImage.swift
//

#if os(macOS)
import Cocoa
public typealias OBSRImage = NSImage
#else
import UIKit
public typealias OBSRImage = UIImage
#endif

public extension OBSRImage {
    convenience init(ft_cgImage: CGImage) {
        #if os(macOS)
        let size: NSSize = .init(width: ft_cgImage.width, height: ft_cgImage.height)
        self.init(cgImage: ft_cgImage, size: size)
        #else
        self.init(cgImage: ft_cgImage)
        #endif
    }
    
    var ft_cgImage: CGImage? {
        #if os(macOS)
        var proposedRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return self.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
        #else
        return self.cgImage
        #endif
    }
}
