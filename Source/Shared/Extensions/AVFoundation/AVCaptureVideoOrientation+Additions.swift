//
//  AVCaptureVideoOrientation+Additions.swift
//  VisionSandbox
//
//  Created by Dave Schukin on 9/2/20.
//  Copyright © 2020 Observant. All rights reserved.
//

import AVFoundation

public extension AVCaptureVideoOrientation {
    
    var ft_debugDescription: String {
        switch self {
        case .portrait: return "portrait"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portraitUpsideDown: return "portraitUpsideDown"
        @unknown default:
            assertionFailure("Unexpected orientation case: \(rawValue)")
            return "unknown"
        }
    }
    
    var ft_landscapeFlippedHorizontally: AVCaptureVideoOrientation {
        switch self {
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return self
        }
    }
    
    var ft_rotatedClockwise: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .landscapeLeft
        case .landscapeLeft: return .portraitUpsideDown
        case .portraitUpsideDown: return .landscapeRight
        case .landscapeRight: return .portrait
        @unknown default:
            assertionFailure("Unexpected orientation case: \(rawValue)")
            return .portrait
        }
    }
}
