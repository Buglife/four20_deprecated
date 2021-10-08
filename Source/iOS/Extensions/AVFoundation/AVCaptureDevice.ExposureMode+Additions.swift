//
//  AVCaptureDevice.ExposureMode+Additions.swift
//

import AVFoundation

@available(macCatalyst 14.0, *)
public extension AVCaptureDevice.ExposureMode {
    var ft_localizedDescription: String {
        switch self {
        case .autoExpose:
            return "Auto expose"
        case .continuousAutoExposure:
            return "Continuous Auto Exposure"
        case .custom:
            return "Custom"
        case .locked:
            return "Locked"
        @unknown default:
            assertionFailure("Unknown AVCaptureDevice.ExposureMode: \(rawValue)")
            return "Unknown"
        }
    }
    
    var ft_debugDescription: String {
        switch self {
        case .autoExpose:
            return "autoExpose"
        case .continuousAutoExposure:
            return "continuousAutoExposure"
        case .custom:
            return "custom"
        case .locked:
            return "locked"
        @unknown default:
            assertionFailure("Unknown AVCaptureDevice.ExposureMode: \(rawValue)")
            return "unknown"
        }
    }
}
