//
//  CVPixelBuffer+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreVideo
import CoreImage
import Accelerate

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
        var totalLuminance: UInt = 0
        for row in Int(denormalizedRect.minX)..<Int(denormalizedRect.maxX) {
            for col in Int(denormalizedRect.minY)..<Int(denormalizedRect.maxY) {
                totalLuminance += UInt(luminanceBytes[row*bytesPerRowOfLuminancePlane + col])
            }
        }
        let cropPixelsCount = UInt(denormalizedRect.width) * UInt(denormalizedRect.height)
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
        case unknown
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
        guard let yImage = pixelBuffer.ft_with({ VImage(ft_pixelBuffer: $0, plane: 0) }) else {
            return .failure(.yImageNil)
        }
        
        guard let cbcrImage = pixelBuffer.ft_with({ VImage(ft_pixelBuffer: $0, plane: 1) }) else {
            return .failure(.cbcrImageNil)
        }
        
        /// Create output pixelBuffer
        guard let outPixelBuffer = CVPixelBuffer.ft_make(width: yImage.width, height: yImage.height, format: kCVPixelFormatType_32BGRA) else {
            return .failure(.outputAllocation)
        }
        
        /// Convert yuv to argb
        guard var argbImage = outPixelBuffer.ft_with({ VImage(ft_pixelBuffer: $0) }) else {
            return .failure(.argbConversion)
        }
        
        do {
            try argbImage.ft_draw(yBuffer: yImage.buffer, cbcrBuffer: cbcrImage.buffer)
        } catch {
            return .failure(.drawing(error))
        }
        
        /// Convert argb to bgra
        argbImage.ft_permute(channelMap: [3, 2, 1, 0])
        return .success(outPixelBuffer)
    }
    
    func ft_with<T>(_ closure: ((_ pixelBuffer: CVPixelBuffer) -> T)) -> T {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        let result = closure(self)
        CVPixelBufferUnlockBaseAddress(self, .readOnly)
        return result
    }
    
    static func ft_make(width: Int, height: Int, format: OSType) -> CVPixelBuffer? {
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

public extension CVPixelBuffer {
    func resizePixelBuffer_BiPlanarYCbCr420(to dstPixelBuffer: CVPixelBuffer,
                                            cropX: Int,
                                            cropY: Int,
                                            cropWidth: Int,
                                            cropHeight: Int,
                                            scaleWidth: Int,
                                            scaleHeight: Int) {
        let srcPixelBuffer = self
        assert(CVPixelBufferGetWidth(dstPixelBuffer) >= scaleWidth)
        assert(CVPixelBufferGetHeight(dstPixelBuffer) >= scaleHeight)
        
        let srcFlags = CVPixelBufferLockFlags.readOnly
        let dstFlags = CVPixelBufferLockFlags(rawValue: 0)
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(srcPixelBuffer, srcFlags) else {
            print("Error could not lock source pixel buffer")
            return
        }
        defer { CVPixelBufferUnlockBaseAddress(srcPixelBuffer, srcFlags) }
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(dstPixelBuffer, dstFlags) else {
            print("Error: could not lock destination pixel buffer")
            return
        }
        defer {
            CVPixelBufferUnlockBaseAddress(dstPixelBuffer, dstFlags)
        }
        guard let srcYData = CVPixelBufferGetBaseAddressOfPlane(srcPixelBuffer, 0),
              let srcCbCrData = CVPixelBufferGetBaseAddressOfPlane(srcPixelBuffer, 1),
              let dstYData = CVPixelBufferGetBaseAddressOfPlane(dstPixelBuffer, 0),
              let dstCbCrData = CVPixelBufferGetBaseAddressOfPlane(dstPixelBuffer, 1) else {
            print("Error: could not get pixel buffer base addresses")
            return
        }
        let srcYBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(srcPixelBuffer, 0)
        let srcCbCrBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(srcPixelBuffer, 1)
        let offsetY = cropY*srcYBytesPerRow + cropX
        let offsetCbCr = cropY / 2 * srcCbCrBytesPerRow + cropX / 2 * 2
        var srcYBuffer = vImage_Buffer(data: srcYData.advanced(by:offsetY),
                                       height: vImagePixelCount(cropHeight),
                                       width: vImagePixelCount(cropWidth),
                                       rowBytes: srcYBytesPerRow)
        var srcCbCrBuffer = vImage_Buffer(data:srcCbCrData.advanced(by:offsetCbCr),
                                          height: vImagePixelCount(cropHeight/2),
                                          width: vImagePixelCount(cropWidth/2),
                                          rowBytes: srcCbCrBytesPerRow)
        
        let dstYBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(dstPixelBuffer, 0)
        let dstCbCrBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(dstPixelBuffer, 1)
        var dstYBuffer = vImage_Buffer(data: dstYData,
                                       height: vImagePixelCount(scaleHeight),
                                       width: vImagePixelCount(scaleWidth),
                                       rowBytes: dstYBytesPerRow)
        var dstCbCrBuffer = vImage_Buffer(data: dstCbCrData,
                                          height: vImagePixelCount(scaleHeight/2),
                                          width: vImagePixelCount(scaleWidth/2),
                                          rowBytes: dstCbCrBytesPerRow)
        var error = vImageScale_Planar8(&srcYBuffer, &dstYBuffer, nil, vImage_Flags(0))
        if error != kvImageNoError {
            print("Error: \(error)")
        }
        error = vImageScale_CbCr8(&srcCbCrBuffer, &dstCbCrBuffer, nil, vImage_Flags(0))
        if error != kvImageNoError {
            print("Error: \(error)")
        }
    }
    /**
     First crops the pixel buffer, then resizes it.
     
     This function requires the caller to pass in both the source and destination
     pixel buffers. The dimensions of destination pixel buffer should be at least
     `scaleWidth` x `scaleHeight` pixels.
     */
    func resizePixelBuffer(to dstPixelBuffer: CVPixelBuffer,
                                  cropX: Int,
                                  cropY: Int,
                                  cropWidth: Int,
                                  cropHeight: Int,
                                  scaleWidth: Int,
                                  scaleHeight: Int) {
        let srcPixelBuffer = self
        assert(CVPixelBufferGetWidth(dstPixelBuffer) >= scaleWidth)
        assert(CVPixelBufferGetHeight(dstPixelBuffer) >= scaleHeight)
        
        let srcFlags = CVPixelBufferLockFlags.readOnly
        let dstFlags = CVPixelBufferLockFlags(rawValue: 0)
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(srcPixelBuffer, srcFlags) else {
            print("Error: could not lock source pixel buffer")
            return
        }
        defer { CVPixelBufferUnlockBaseAddress(srcPixelBuffer, srcFlags) }
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(dstPixelBuffer, dstFlags) else {
            print("Error: could not lock destination pixel buffer")
            return
        }
        defer { CVPixelBufferUnlockBaseAddress(dstPixelBuffer, dstFlags) }
        
        guard let srcData = CVPixelBufferGetBaseAddress(srcPixelBuffer),
              let dstData = CVPixelBufferGetBaseAddress(dstPixelBuffer) else {
            print("Error: could not get pixel buffer base address")
            return
        }
        
        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(srcPixelBuffer)
        let offset = cropY*srcBytesPerRow + cropX*4
        var srcBuffer = vImage_Buffer(data: srcData.advanced(by: offset),
                                      height: vImagePixelCount(cropHeight),
                                      width: vImagePixelCount(cropWidth),
                                      rowBytes: srcBytesPerRow)
        
        let dstBytesPerRow = CVPixelBufferGetBytesPerRow(dstPixelBuffer)
        var dstBuffer = vImage_Buffer(data: dstData,
                                      height: vImagePixelCount(scaleHeight),
                                      width: vImagePixelCount(scaleWidth),
                                      rowBytes: dstBytesPerRow)
        
        let error = vImageScale_ARGB8888(&srcBuffer, &dstBuffer, nil, vImage_Flags(0))
        if error != kvImageNoError {
            print("Error:", error)
        }
    }
    
    /**
     First crops the pixel buffer, then resizes it.
     
     This allocates a new destination pixel buffer that is Metal-compatible.
     */
    func resizePixelBuffer(cropX: Int,
                                  cropY: Int,
                                  cropWidth: Int,
                                  cropHeight: Int,
                                  scaleWidth: Int,
                                  scaleHeight: Int) -> CVPixelBuffer? {
        let srcPixelBuffer = self
        let pixelFormat = CVPixelBufferGetPixelFormatType(srcPixelBuffer)
        let dstPixelBuffer = CVPixelBuffer.createMetalIOSurfacePixelBuffer(width: scaleWidth, height: scaleHeight,
                                               pixelFormat: pixelFormat)
        
        if let dstPixelBuffer = dstPixelBuffer {
            CVBufferPropagateAttachments(srcPixelBuffer, dstPixelBuffer)
            
            if pixelFormat == kCVPixelFormatType_32BGRA {
                resizePixelBuffer(to: dstPixelBuffer,
                                  cropX: cropX, cropY: cropY,
                                  cropWidth: cropWidth, cropHeight: cropHeight,
                                  scaleWidth: scaleWidth, scaleHeight: scaleHeight)
            } else if pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                resizePixelBuffer_BiPlanarYCbCr420(to: dstPixelBuffer,
                                                   cropX: cropX,cropY: cropY,
                                                   cropWidth: cropWidth, cropHeight: cropHeight,
                                                   scaleWidth: scaleWidth, scaleHeight: scaleHeight)
            }
        }
        
        return dstPixelBuffer
    }
    
    /**
     Resizes a CVPixelBuffer to a new width and height.
     
     This function requires the caller to pass in both the source and destination
     pixel buffers. The dimensions of destination pixel buffer should be at least
     `width` x `height` pixels.
     */
    func resizePixelBuffer(to dstPixelBuffer: CVPixelBuffer,
                                  width: Int, height: Int) {
        let srcPixelBuffer = self
        resizePixelBuffer(to: dstPixelBuffer,
                          cropX: 0, cropY: 0,
                          cropWidth: CVPixelBufferGetWidth(srcPixelBuffer),
                          cropHeight: CVPixelBufferGetHeight(srcPixelBuffer),
                          scaleWidth: width, scaleHeight: height)
    }
    
    /**
     Resizes a CVPixelBuffer to a new width and height.
     
     This allocates a new destination pixel buffer that is Metal-compatible.
     */
    func resizePixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let pixelBuffer = self
        return resizePixelBuffer(cropX: 0, cropY: 0,
                                 cropWidth: CVPixelBufferGetWidth(pixelBuffer),
                                 cropHeight: CVPixelBufferGetHeight(pixelBuffer),
                                 scaleWidth: width, scaleHeight: height)
    }
    
    /**
     Resizes a CVPixelBuffer to a new width and height, using Core Image.
     */
    func resizePixelBuffer(width: Int, height: Int,
                                  output: CVPixelBuffer, context: CIContext) {
        let pixelBuffer = self
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(width) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(height) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform, highQualityDownsample:true)
        context.render(scaledImage, to: output)
    }
    
    
    fileprivate static func metalCompatiblityAttributes() -> [String: Any] {
        let attributes: [String: Any] = [
            String(kCVPixelBufferMetalCompatibilityKey): true,
            String(kCVPixelBufferOpenGLCompatibilityKey): true,
            String(kCVPixelBufferIOSurfacePropertiesKey): [
                String(kCVPixelBufferIOSurfaceOpenGLESTextureCompatibilityKey): true,
                String(kCVPixelBufferIOSurfaceOpenGLESFBOCompatibilityKey): true,
                String(kCVPixelBufferIOSurfaceCoreAnimationCompatibilityKey): true
            ]
        ]
        return attributes
    }
    
    /**
     Creates a pixel buffer of the specified width, height, and pixel format.
     - Note: This pixel buffer is backed by an IOSurface and therefore can be
     turned into a Metal texture.
     */
    static func createMetalIOSurfacePixelBuffer(width: Int, height: Int, pixelFormat: OSType) -> CVPixelBuffer? {
        let attributes = CVPixelBuffer.metalCompatiblityAttributes() as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(nil, width, height, pixelFormat, attributes, &pixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create pixel buffer", status)
            return nil
        }
        return pixelBuffer
    }
    
    /**
     Creates a RGB pixel buffer of the specified width and height.
     */
    static func createMetalIOSurfaceBGRAPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        createMetalIOSurfacePixelBuffer(width: width, height: height, pixelFormat: kCVPixelFormatType_32BGRA)
    }
}

