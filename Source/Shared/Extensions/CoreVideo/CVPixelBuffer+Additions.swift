//
//  CVPixelBuffer+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreVideo

#if !os(macOS)
import UIKit
#endif

public extension CVPixelBuffer {
    func ft_imageWithContext(_ ciContext: CIContext) -> OBSRImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        guard let cgImage = ciContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) else {
            return nil
        }
        return OBSRImage(ft_cgImage: cgImage)
    }
}

public extension CVPixelBuffer {
    var ft_pixelFormatType: OSType { CVPixelBufferGetPixelFormatType(self) }
    
    var ft_size: CGSize {
        CGSize(width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))
    }
    
    // MARK: - Helpers that are used more often than you'd think
    
    func ft_CGImageCroppedTo(_ denormalizedRect: CGRect) -> CGImage? {
        let context = CIContext()
        guard let uiImage = ft_imageWithContext(context) else { return nil }
        guard let cgImage = uiImage.ft_cgImage else { return nil }
        return cgImage.cropping(to: denormalizedRect)
    }
    
    func ft_CGImageCroppedTo(normalizedRect: CGRect) -> CGImage? {
        let denormalizedRect = normalizedRect * ft_size
        return ft_CGImageCroppedTo(denormalizedRect)
    }
    
    // MARK: - BGRA conversion
    
    enum BGRAConversionError: Swift.Error {
        case unexpectedPixelFormat
        case drawing(Swift.Error)
        case yImageNil
        case cbcrImageNil
        case outputAllocation
        case argbConversion
    }
    
    func ft_toBGRA() -> Result<CVPixelBuffer, BGRAConversionError> {
        let pixelBuffer = self
        
        /// Check format
        let pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        
        guard pixelFormat != kCVPixelFormatType_32BGRA else {
            return .success(self)
        }
        
        guard pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange else {
            print("unexpected pixel format: \(pixelFormat)")
            return .failure(.unexpectedPixelFormat)
            
        }
        
        /// Split plane
        guard let yImage = pixelBuffer.with({ VImage(ft_pixelBuffer: $0, plane: 0) }) else {
            return .failure(.yImageNil)
        }
        
        guard let cbcrImage = pixelBuffer.with({ VImage(ft_pixelBuffer: $0, plane: 1) }) else {
            return .failure(.cbcrImageNil)
        }
        
        /// Create output pixelBuffer
        guard let outPixelBuffer = CVPixelBuffer.make(width: yImage.width, height: yImage.height, format: kCVPixelFormatType_32BGRA) else {
            return .failure(.outputAllocation)
        }
        
        /// Convert yuv to argb
        guard var argbImage = outPixelBuffer.with({ VImage(ft_pixelBuffer: $0) }) else {
            return .failure(.argbConversion)
        }
        
        do {
            try argbImage.draw(yBuffer: yImage.buffer, cbcrBuffer: cbcrImage.buffer)
        } catch {
            return .failure(.drawing(error))
        }
        
        /// Convert argb to bgra
        argbImage.permute(channelMap: [3, 2, 1, 0])
        return .success(outPixelBuffer)
    }
    
    private func with<T>(_ closure: ((_ pixelBuffer: CVPixelBuffer) -> T)) -> T {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        let result = closure(self)
        CVPixelBufferUnlockBaseAddress(self, .readOnly)
        return result
    }
    
    private static func make(width: Int, height: Int, format: OSType) -> CVPixelBuffer? {
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
