//
//  Notification.Name+AVFoundation.swift
//

import AVFoundation

public extension Notification.Name {
    
    /// Redefines a notification within an internal system framework that signals a volume change.
    /// # Reference
    /// [StackOverflow](https://www.google.com/search?q=AVSystemController+site:stackoverflow.com)
    static let ft_AVSystemController_SystemVolumeDidChangeNotification = Notification.Name("AVSystemController_SystemVolumeDidChangeNotification")
    
    /// Private API, see `MPAVLightweightRoutingController.h`
    static let ft_AVOutputContextOutputDeviceDidChangeNotification = Notification.Name("AVOutputContextOutputDeviceDidChangeNotification")
    
    /// Private API, see `MPAVLightweightRoutingController.h`
    static let ft_AVOutputDeviceDiscoverySessionAvailableOutputDevicesDidChangeNotification = Notification.Name("AVOutputDeviceDiscoverySessionAvailableOutputDevicesDidChangeNotification")
    
    // MARK: - Debugging
    
    var ft_audioDebugDescription: String {
        switch self {
        case AVAudioSession.interruptionNotification:
            return "interruption"
        case AVAudioSession.routeChangeNotification:
            return "routeChange"
        case AVAudioSession.mediaServicesWereResetNotification:
            return "mediaServicesWereReset"
        case AVAudioSession.mediaServicesWereLostNotification:
            return "mediaServicesWereLost"
        case .ft_AVSystemController_SystemVolumeDidChangeNotification:
            return "systemVolumeDidChange"
        case .ft_AVOutputContextOutputDeviceDidChangeNotification:
            return "outputDeviceDidChange"
        case .ft_AVOutputDeviceDiscoverySessionAvailableOutputDevicesDidChangeNotification:
            return "availableOutputDevicesDidChange"
        default:
            return rawValue
        }
    }
}
