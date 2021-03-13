//
//  AVCaptureDevice+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import AVFoundation

private let kFrontCameraAspectRatio: CGFloat = 4.0 / 3.0

public extension AVCaptureDevice {
    enum FlashlightError: Swift.Error {
        case noCaptureDevice // what the fuck
        case torchNotAvailable
        case wrapped(Swift.Error)
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
}

extension AVCaptureDevice.FlashlightError: CustomDebugStringConvertible {
    public var ft_description: String {
        switch self {
        case .noCaptureDevice:
            return "No capture device"
        case .torchNotAvailable:
            return "Flashlight not available"
        case .wrapped(let error):
            return "\(error.localizedDescription)"
        }
    }
    
    public var debugDescription: String {
        return "FlashlightError: \(ft_description))"
    }
}

public extension AVCaptureDevice.ExposureMode {
    var ft_description: String {
        switch self {
        case .autoExpose:
            return "Auto expose"
        case .continuousAutoExposure:
            return "Continuous"
        case .custom:
            return "Custom"
        case .locked:
            return "Locked"
        default:
            assertionFailure("Unexpected exposure mode: \(self.rawValue)")
            return "Unexpected"
        }
    }
}

public extension AVCaptureDevice.Position {
    var ft_debugDescription: String {
        switch self {
        case .front: return "front"
        case .back: return "back"
        case .unspecified: return "unspecified"
        @unknown default:
            assertionFailure()
            return "unknown"
        }
    }
}

public extension AVCaptureDevice.DeviceType {
    var ft_debugDescription: String {
        /// know a better way to do this? cause that would be great
        if #available(iOS 13.0, *) {
            switch self {
            case .builtInMicrophone: return "builtInMicrophone"
            case .builtInWideAngleCamera: return "builtInWideAngleCamera"
            case .builtInTelephotoCamera: return "builtInTelephotoCamera"
            case .builtInUltraWideCamera: return "builtInUltraWideCamera"
            case .builtInDualCamera: return "builtInDualCamera"
            case .builtInDualWideCamera: return "builtInDualWideCamera"
            case .builtInTripleCamera: return "builtInTripleCamera"
            case .builtInTrueDepthCamera: return "builtInTrueDepthCamera"
            default: return "unknown"
            }
        } else {
            switch self {
            case .builtInMicrophone: return "builtInMicrophone"
            case .builtInWideAngleCamera: return "builtInWideAngleCamera"
            case .builtInTelephotoCamera: return "builtInTelephotoCamera"
            case .builtInDualCamera: return "builtInDualCamera"
            case .builtInTrueDepthCamera: return "builtInTrueDepthCamera"
            default: return "unknown"
            }
        }
    }
}

public extension Array where Element == AVCaptureDevice.DeviceType {
    static var ft_all: [AVCaptureDevice.DeviceType] {
        /// make sure these are in the same order as which they're defined (at least in the headers),
        /// cause chances are some debug code will render them in a table in the same order
        var all: [AVCaptureDevice.DeviceType] = []
        
        all.append(contentsOf: [
            .builtInMicrophone,
            .builtInWideAngleCamera,
            .builtInTelephotoCamera
        ])
        
        if #available(iOS 13.0, *) {
            all.append(.builtInUltraWideCamera)
        }
        
        all.append(.builtInDualCamera)
        
        if #available(iOS 13.0, *) {
            all.append(.builtInDualWideCamera)
            all.append(.builtInTripleCamera)
        }
        
        all.append(.builtInTrueDepthCamera)
        return all
    }
}
