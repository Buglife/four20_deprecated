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
    
    var ft_modelIdentifier: String? {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)
    }
    
    /// List is incomplete, see https://www.theiphonewiki.com/wiki/Models
    var ft_model: String? {
        guard let m = ft_modelIdentifier else { return nil }
        
        switch m {
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,6": return "iPhone XS Max"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE (2nd gen)"
        case "iPhone13,1": return "iPhone 12 mini" // Apple doesn't capitalize "mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd gen)"
        case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd gen)"
        case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th gen)"
        default:
            return m
        }
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
