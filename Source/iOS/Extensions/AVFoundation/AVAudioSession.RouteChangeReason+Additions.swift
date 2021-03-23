//
//  AVAudioSessionRouteChangeReason+Additions.swift
//

import AVFoundation

public extension AVAudioSession.RouteChangeReason {
    var ft_debugDescription: String {
        switch self {
        case .categoryChange: return "categoryChange"
        case .unknown: return "unknown"
        case .newDeviceAvailable: return "newDeviceAvailable"
        case .oldDeviceUnavailable: return "oldDeviceUnavailable"
        case .override: return "override"
        case .wakeFromSleep: return  "wakeFromSleep"
        case .noSuitableRouteForCategory: return "noSuitableRouteForCategory"
        case .routeConfigurationChange: return "routeConfigurationChange"
        @unknown default: return "unknown"
        }
    }
}
