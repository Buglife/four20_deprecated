//
//  UIDeviceAdditions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

public extension UIDevice {
    var ft_exifOrientation: CGImagePropertyOrientation {
        return orientation.ft_exifOrientation
    }
}

public extension UIDeviceOrientation {
    var ft_exifOrientation: CGImagePropertyOrientation {
        switch self {
        case .portraitUpsideDown:
            return .rightMirrored
        case .landscapeLeft:
            return .downMirrored
        case .landscapeRight:
            return .upMirrored
        default:
            return .leftMirrored
        }
    }
    
    var ft_description: String {
        switch self {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait upside down"
        case .landscapeLeft: return "Landscape left"
        case .landscapeRight: return "Landscape right"
        case .faceUp: return "Face up"
        case .faceDown: return "Face down"
        case .unknown: return "Unknown"
        @unknown default:
            return "Unknown(\(rawValue))"
        }
    }
}

public extension UIDevice.BatteryState {
    var ft_description: String {
        switch self {
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        @unknown default:
            return "Unknown"
        }
    }
}

extension UIDeviceOrientation: Codable {}
