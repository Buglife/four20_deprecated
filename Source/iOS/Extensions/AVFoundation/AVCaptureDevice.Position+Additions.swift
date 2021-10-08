//
//  AVCaptureDevice.Position.swift
//

import AVFoundation

@available(macCatalyst 14.0, *)
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
