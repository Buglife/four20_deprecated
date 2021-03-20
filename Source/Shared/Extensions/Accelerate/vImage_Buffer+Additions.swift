//
//  vImage_Buffer+Additions.swift
//  Four20
//
//  Created by Dave Schukin on 9/4/20.
//

import Accelerate

public extension vImage_Buffer {
    mutating func ft_draw(yBuffer: vImage_Buffer, cbcrBuffer: vImage_Buffer) throws {
        var yBuffer = yBuffer
        var cbcrBuffer = cbcrBuffer
        var conversionMatrix: vImage_YpCbCrToARGB = {
            var pixelRange = vImage_YpCbCrPixelRange(Yp_bias: 0, CbCr_bias: 128, YpRangeMax: 255, CbCrRangeMax: 255, YpMax: 255, YpMin: 1, CbCrMax: 255, CbCrMin: 0)
            var matrix = vImage_YpCbCrToARGB()
            vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_709_2, &pixelRange, &matrix, kvImage420Yp8_CbCr8, kvImageARGB8888, UInt32(kvImageNoFlags))
            return matrix
        }()
        let error = vImageConvert_420Yp8_CbCr8ToARGB8888(&yBuffer, &cbcrBuffer, &self, &conversionMatrix, nil, 255, UInt32(kvImageNoFlags))
        if error != kvImageNoError {
            fatalError()
        }
    }
    
    mutating func ft_permute(channelMap: [UInt8]) {
        vImagePermuteChannels_ARGB8888(&self, &self, channelMap, 0)
    }
}

public struct VImage {
    public let width: Int
    public let height: Int
    public let bytesPerRow: Int
    public var buffer: vImage_Buffer
    
    public init?(ft_pixelBuffer: CVPixelBuffer, plane: Int) {
        guard let rawBuffer = CVPixelBufferGetBaseAddressOfPlane(ft_pixelBuffer, plane) else { return nil }
        self.width = CVPixelBufferGetWidthOfPlane(ft_pixelBuffer, plane)
        self.height = CVPixelBufferGetHeightOfPlane(ft_pixelBuffer, plane)
        self.bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(ft_pixelBuffer, plane)
        self.buffer = vImage_Buffer(
            data: UnsafeMutableRawPointer(mutating: rawBuffer),
            height: vImagePixelCount(height),
            width: vImagePixelCount(width),
            rowBytes: bytesPerRow
        )
    }
    
    public init?(ft_pixelBuffer: CVPixelBuffer) {
        guard let rawBuffer = CVPixelBufferGetBaseAddress(ft_pixelBuffer) else { return nil }
        self.width = CVPixelBufferGetWidth(ft_pixelBuffer)
        self.height = CVPixelBufferGetHeight(ft_pixelBuffer)
        self.bytesPerRow = CVPixelBufferGetBytesPerRow(ft_pixelBuffer)
        self.buffer = vImage_Buffer(
            data: UnsafeMutableRawPointer(mutating: rawBuffer),
            height: vImagePixelCount(height),
            width: vImagePixelCount(width),
            rowBytes: bytesPerRow
        )
    }
    
    public mutating func ft_draw(yBuffer: vImage_Buffer, cbcrBuffer: vImage_Buffer) throws {
        try buffer.ft_draw(yBuffer: yBuffer, cbcrBuffer: cbcrBuffer)
    }
    
    public mutating func ft_permute(channelMap: [UInt8]) {
        buffer.ft_permute(channelMap: channelMap)
    }
}
