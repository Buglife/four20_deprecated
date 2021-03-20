//
//  AVCaptureDevice+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import AVFoundation

private let kFrontCameraAspectRatio: CGFloat = 4.0 / 3.0

public extension AVCaptureDevice {
    
    /// - Parameter mediaType: default value is `.video`
    /// - Parameter position: default value is `.unspecified`
    class func ft_availableCaptureDevices(mediaType: AVMediaType = .video, position: AVCaptureDevice.Position = .unspecified) -> [AVCaptureDevice] {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: .ft_all, mediaType: .video, position: position)
        return session.devices.sorted { $0.ft_deviceTypeAndPosition < $1.ft_deviceTypeAndPosition }
    }
    
    class var ft_frontFacingTrueDepthCamera: AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front)
    }
    
    class var ft_frontFacingTrueDepthCameraAspectRatio: CGFloat {
        guard let device = ft_frontFacingTrueDepthCamera else {
            return kFrontCameraAspectRatio
        }
        
        let formatDescription = device.activeFormat.formatDescription
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        return CGFloat(dimensions.width) / CGFloat(dimensions.height)
    }
    
    class var ft_isFlashlightOn: Bool {
        get {
            guard let captureDevice = ft_captureDeviceForFlashlight else { return false }
            return captureDevice.isTorchActive
        }
    }
    
    @discardableResult
    class func ft_setIsFlashlightOn(_ newValue: Bool) -> FlashlightError? {
        guard let captureDevice = ft_captureDeviceForFlashlight else { return .noCaptureDevice }
        
        if newValue {
            if captureDevice.isTorchAvailable {
                do {
                    try captureDevice.lockForConfiguration()
                    captureDevice.torchMode = .on
                    try captureDevice.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                } catch {
                    print("Error enabling flashlight: \(error)")
                    return .wrapped(error)
                }
            } else {
                print("Error enabling flashlight: Torch unavailable")
                return .torchNotAvailable
            }
        } else {
            captureDevice.torchMode = .off
            captureDevice.unlockForConfiguration()
        }
        
        return nil
    }
    
    private class var ft_captureDeviceForFlashlight: AVCaptureDevice? {
        return AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .back)
    }
    
    /// Used for sorting, debugging, or whatever.
    var ft_deviceTypeAndPosition: String {
        position.ft_debugDescription + " " + deviceType.ft_debugDescription
    }
}
