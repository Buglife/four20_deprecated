//
//  CVPixelBuffer+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreVideo

#if !os(macOS)
import UIKit

public extension CVPixelBuffer {
    func ft_imageWithContext(_ ciContext: CIContext) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        guard let cgImage = ciContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
#endif

public extension CVPixelBuffer {
    public func toBGRA() throws -> CVPixelBuffer? {
        let pixelBuffer = self
        
        /// Check format
        let pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        guard pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange else {
            print("unexpected pixel format: \(pixelFormat)")
            return pixelBuffer
            
        }
        
        /// Split plane
        let yImage = pixelBuffer.with({ VImage(ft_pixelBuffer: $0, plane: 0) })!
        let cbcrImage = pixelBuffer.with({ VImage(ft_pixelBuffer: $0, plane: 1) })!
        
        /// Create output pixelBuffer
        let outPixelBuffer = CVPixelBuffer.make(width: yImage.width, height: yImage.height, format: kCVPixelFormatType_32BGRA)!
        
        /// Convert yuv to argb
        var argbImage = outPixelBuffer.with({ VImage(ft_pixelBuffer: $0) })!
        try argbImage.draw(yBuffer: yImage.buffer, cbcrBuffer: cbcrImage.buffer)
        /// Convert argb to bgra
        argbImage.permute(channelMap: [3, 2, 1, 0])
        
        return outPixelBuffer
    }
    
    func with<T>(_ closure: ((_ pixelBuffer: CVPixelBuffer) -> T)) -> T {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        let result = closure(self)
        CVPixelBufferUnlockBaseAddress(self, .readOnly)
        return result
    }
    
    static func make(width: Int, height: Int, format: OSType) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            format,
                            nil,
                            &pixelBuffer)
        return pixelBuffer
    }
}
