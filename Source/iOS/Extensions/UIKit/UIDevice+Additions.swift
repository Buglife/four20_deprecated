//
//  UIDeviceAdditions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

public extension UIDevice {
    /// **Deprecated.** Returns the exif orientation equivalent to the current device orientation. Typically used when you're
    /// giving an image to Vision but don't have its orientation (i.e. the image is is an ARKit pixel buffer without
    /// orientation metadata), and you want to just get the current device orientation.
    ///
    /// - Warning: We have found that `UIDevice.orientation` is *NOT* a reliable method
    /// of obtaining the actual device orienation, and may in some cases return `.unknown`.
    @available(*, deprecated, message: "UIDevice orientation is not reliable")
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
