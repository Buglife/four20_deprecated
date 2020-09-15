//
//  AVAsset+Additions.swift
//

import AVFoundation
import CoreMedia

public extension AVAsset {
    
    enum FrameExtractionError: Swift.Error {
        case assetReader(Swift.Error)
        case missingVideoTrack
    }
    
    private var ft_frames: Result<[CMSampleBuffer], FrameExtractionError> {
        let assetReader: AVAssetReader
        
        do {
            assetReader = try AVAssetReader(asset: self)
        } catch {
            return .failure(.assetReader(error))
        }
        
        guard let videoTrack = self.tracks(withMediaType: .video).last else {
            return .failure(.missingVideoTrack)
        }
        
        let readerOutputSettings: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerOutputSettings)
        assetReader.add(readerOutput)
        assetReader.startReading()
        
        var sampleBuffers: [CMSampleBuffer] = []
        while let sampleBuffer = readerOutput.copyNextSampleBuffer() {
            sampleBuffers.append(sampleBuffer)
        }
        
        return .success(sampleBuffers)
    }
    
    typealias FrameEnumerator<T> = (CMSampleBuffer) -> (T)
    
    /// - Warning: this is NOT safe to use in production code, due to hard preconditions within
    func ft_mapFrames<T>(handler: FrameEnumerator<T>) -> [T] {
        let assetReader: AVAssetReader
        
        do {
            assetReader = try AVAssetReader(asset: self)
        } catch {
            preconditionFailure("Failed to enumerate frames for asset \(self):\n\(error)")
        }
        
        guard let videoTrack = self.tracks(withMediaType: .video).last else {
            preconditionFailure("Failed to get video track for asset \(self)")
        }
        
        let readerOutputSettings: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerOutputSettings)
        assetReader.add(readerOutput)
        assetReader.startReading()
        
        var results: [T] = []
        while let sampleBuffer = readerOutput.copyNextSampleBuffer() {
            let result = handler(sampleBuffer)
            results.append(result)
        }
        
        return results
    }
    
    var ft_naturalSize: CGSize? {
        tracks(withMediaType: .video).first?.naturalSize
    }
    
    var ft_aspectRatio: CGFloat? {
        guard let size = ft_naturalSize else { return nil }
        return size.width / size.height
    }
}
