//
//  AVCaptureDevice.DeviceType.swift
//

import AVFoundation

public extension AVCaptureDevice.DeviceType {
    var ft_debugDescription: String {
        guard let debugDescription = type(of: self).ft_casesAndDebugDescriptions[self] else {
            assertionFailure("Unknown AVCaptureDevice.DeviceType: \(rawValue)")
            return "unknown"
        }
        
        return debugDescription
    }
    
    var ft_localizedDescription: String {
        guard let debugDescription = type(of: self).ft_casesAndLocalizedDescriptions[self] else {
            assertionFailure("Unknown AVCaptureDevice.DeviceType: \(rawValue)")
            return "unknown"
        }
        
        return debugDescription
    }
    
    private static let ft_casesAndDebugDescriptions: [AVCaptureDevice.DeviceType : String] = {
        var result: [AVCaptureDevice.DeviceType : String] = [
            .builtInMicrophone : "builtInMicrophone",
            .builtInWideAngleCamera : "builtInWideAngleCamera",
            .builtInTelephotoCamera : "builtInTelephotoCamera",
            .builtInDualCamera : "builtInDualCamera",
            .builtInTrueDepthCamera : "builtInTrueDepthCamera"
        ]
        
        if #available(iOS 13.0, *) {
            result[.builtInUltraWideCamera] = "builtInUltraWideCamera"
            result[.builtInDualWideCamera] = "builtInDualWideCamera"
            result[.builtInTripleCamera] = "builtInTripleCamera"
        }
        
        return result
    }()
    
    private static let ft_casesAndLocalizedDescriptions: [AVCaptureDevice.DeviceType : String] = {
        var result: [AVCaptureDevice.DeviceType : String] = [
            .builtInMicrophone : "Microphone",
            .builtInWideAngleCamera : "Wide Angle",
            .builtInTelephotoCamera : "Telephoto",
            .builtInDualCamera : "Dual",
            .builtInTrueDepthCamera : "TrueDepth"
        ]
        
        if #available(iOS 13.0, *) {
            result[.builtInUltraWideCamera] = "Ultra Wide"
            result[.builtInDualWideCamera] = "Dual Wide"
            result[.builtInTripleCamera] = "Triple"
        }
        
        return result
    }()
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
