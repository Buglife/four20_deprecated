//
//  AVCaptureDevice+Additions.swift
//

import AVFoundation

public extension AVCaptureSession {
    enum Error: Swift.Error {
        case unknown
        case captureDeviceUnavailable
        case captureDeviceInput(Swift.Error)
        case unableToAddInput
        case unableToAddOutput
    }
    
    typealias SampleBufferDelegateAndQueue = (AVCaptureVideoDataOutputSampleBufferDelegate, DispatchQueue)
    
    class func ft_session(output: AVCaptureVideoDataOutput) -> Result<AVCaptureSession, Error> {
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return .failure(.captureDeviceUnavailable)
        }
        
        let deviceInput: AVCaptureDeviceInput
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return .failure(.captureDeviceInput(error))
        }
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        } else {
            return .failure(.unableToAddInput)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            return .failure(.unableToAddOutput)
        }
        
        session.commitConfiguration()
        return .success(session)
    }
    
    /// Prefixed with `debug` because this assumes that there's only one `AVCaptureVideoDataOutput`,
    /// and you almost certainly don't want to use this in any production code
    var ft_debugVideoDataOutput: AVCaptureVideoDataOutput? {
        for output in outputs {
            if let videoDataOutput = output as? AVCaptureVideoDataOutput {
                return videoDataOutput
            }
        }

        return nil
    }
}

public extension AVCaptureVideoDataOutput {
    static func ft_captureVideoDataOutput(pixelBufferPixelFormatType: OSType?) -> AVCaptureVideoDataOutput {
        let result = AVCaptureVideoDataOutput()
        
        if let pixelBufferPixelFormatType = pixelBufferPixelFormatType {
            result.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(pixelBufferPixelFormatType)
            ]
        }
        
        return result
    }
    
    static func ft_captureVideoDataOutputForClassificationDebugging() -> AVCaptureVideoDataOutput {
        /// I don't know why we use this pixelBufferPixelFormatType, this code may have been derived from stack overflow
        return .ft_captureVideoDataOutput(pixelBufferPixelFormatType: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
    }
}
