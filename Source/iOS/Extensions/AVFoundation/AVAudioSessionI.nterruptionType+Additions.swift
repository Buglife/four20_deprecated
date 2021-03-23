//
//  AVAudioSession.InterruptionType+Additions.swift
//

import AVFoundation

public extension AVAudioSession.InterruptionType {
    var ft_debugDescription: String {
        switch self {
        case .began: return "began"
        case .ended: return "ended"
        @unknown default: return "unknown"
        }
    }
}
