//
//  Notification.Name+AVFoundation.swift
//

import AVFoundation

public extension Notification.Name {
    
    /// Redefines a notification within an internal system framework that signals a volume change.
    /// # Reference
    /// [StackOverflow](https://www.google.com/search?q=AVSystemController+site:stackoverflow.com)
    static let ft_AVSystemController_SystemVolumeDidChangeNotification = Notification.Name("AVSystemController_SystemVolumeDidChangeNotification")
    
    // MARK: - Debugging
    
    var ft_audioDebugDescription: String {
        switch self {
        case AVAudioSession.interruptionNotification:
            return "interruptionNotification"
        case AVAudioSession.routeChangeNotification:
            return "routeChangeNotification"
        case AVAudioSession.mediaServicesWereResetNotification:
            return "mediaServicesWereResetNotification"
        case AVAudioSession.mediaServicesWereLostNotification:
            return "mediaServicesWereLostNotification"
        case .ft_AVSystemController_SystemVolumeDidChangeNotification:
            return "systemVolumeDidChangeNotification"
        default:
            return rawValue
        }
    }
}
