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
    func ft_luminanceIn(normalizedRect: CGRect) -> Double? {
        let denormalizedRect = normalizedRect * ft_size
        return ft_luminanceIn(denormalizedRect)
    }
    func ft_luminanceIn(_ denormalizedRect: CGRect) -> Double? {
        let pixelFormat = CVPixelBufferGetPixelFormatType(self)
        
        guard pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange else {
            ft_assertionFailure("unexpected pixel format: \(pixelFormat)")
            return nil
        }
        CVPixelBufferLockBaseAddress(self, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(self, .readOnly)
        }
        guard let baseOfLuminancePlane = CVPixelBufferGetBaseAddressOfPlane(self, 0) else {
            ft_assertionFailure("failed to get luminance plane")
            return nil
        }
        let totalLuminancePlaneSize = CVPixelBufferGetWidthOfPlane(self, 0) * CVPixelBufferGetHeightOfPlane(self, 0)
        let bytesPerRowOfLuminancePlane = CVPixelBufferGetBytesPerRowOfPlane(self, 0)
        let luminanceBytes = baseOfLuminancePlane.bindMemory(to: UInt8.self, capacity: totalLuminancePlaneSize)
        var totalLuminance: Int = 0
        for row in Int(denormalizedRect.minX)..<Int(denormalizedRect.maxX) {
            for col in Int(denormalizedRect.minY)..<Int(denormalizedRect.maxY) {
                totalLuminance += Int(luminanceBytes[row*bytesPerRowOfLuminancePlane + col])
            }
        }
        let cropPixelsCount = Int(denormalizedRect.width) * Int(denormalizedRect.height)
        return Double(totalLuminance)/Double(cropPixelsCount)
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
