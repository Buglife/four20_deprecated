//
//  UIInterfaceOrientation+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

extension UIInterfaceOrientation {
    var ft_description: String {
        switch self {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait upside down"
        case .landscapeLeft: return "Landscape left"
        case .landscapeRight: return "Landscape right"
        case .unknown: return "Unknown"
        @unknown default:
            return "Unknown(\(rawValue))"
        }
    }
}

extension UIInterfaceOrientation: Codable {}
