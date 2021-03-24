//
//  Notification+AVAudioSession.swift
//

import AVFoundation

/// Private API. See `AVSystemController_SystemVolumeDidChangeNotification`
fileprivate let AVSystemController_AudioVolumeNotificationParameterKey = "AVSystemController_AudioVolumeNotificationParameter"
/// Private API. See `AVSystemController_SystemVolumeDidChangeNotification`
fileprivate let AVSystemController_AudioCategoryNotificationParameterKey = "AVSystemController_AudioCategoryNotificationParameter"
/// Private API. See `AVSystemController_SystemVolumeDidChangeNotification`
fileprivate let AVSystemController_AudioVolumeChangeReasonNotificationParameterKey = "AVSystemController_AudioVolumeChangeReasonNotificationParameter"
/// Private API. See `AVSystemController_SystemVolumeDidChangeNotification`
fileprivate let AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameterKey = "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter"
/// Private API. See `AVSystemController_SystemVolumeDidChangeNotification`
fileprivate let AVSystemController_AudioVolumeChangeReasonExplicitVolumeChange = "ExplicitVolumeChange"

public extension Notification {
    
    // MARK: - Debug descriptions
    
    /// Returns a debug description that assumes the notification is one of those defined in AVFoundation.
    /// # Reference
    /// [AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession)
    /// [AVSystemController](https://github.com/JaviSoto/iOS10-Runtime-Headers/blob/master/PrivateFrameworks/Celestial.framework/AVSystemController.h)
    var ft_audioDebugDescription: String {
        let readableName = name.ft_audioDebugDescription
        
        if let userInfoStr = ft_audioUserInfoString {
            return "\(readableName) | \(userInfoStr)"
        } else {
            return readableName
        }
    }
    
    private var ft_audioUserInfoString: String? {
        guard let userInfo = self.userInfo else { return nil }
        let userInfoStrs = userInfo.ft_audioUserInfo
        
        let pairs: [String] = userInfoStrs.keys.sorted().reversed().map { key in
            let val = userInfoStrs[key] ?? "nil"
            return "\(key): \(val)"
        }
        guard !pairs.isEmpty else { return nil }
        return pairs.joined(separator: ", ")
    }
    
    // MARK: - Accessors
    
    /// Returns the new volume when the notification is a `AVSystemController_SystemVolumeDidChangeNotification`.
    var ft_audioVolume: Float? {
        userInfo?[AVSystemController_AudioVolumeNotificationParameterKey] as? Float
    }
    
    /// Returns `true` if the reason for the volume change was the user pressing the hardware keys
    /// (buttons on the side of the phone).
    /// - Note: To return `true`, this requires a key that AFAIK is only provided in `AVSystemController_SystemVolumeDidChangeNotification` notifications.
    var ft_isExplicitVolumeChange: Bool {
        guard let reason = userInfo?[AVSystemController_AudioVolumeChangeReasonNotificationParameterKey] as? String else { return false }
        return reason == AVSystemController_AudioVolumeChangeReasonExplicitVolumeChange
    }
    
    /// Returns the audio category for `AVSystemController_SystemVolumeDidChangeNotification`.
    /// - Warning: the values returned by this method are NOT the same as AVAudioSession's categories, and are not publicly defined by Apple.
    var ft_audioCategory: String? {
        userInfo?[AVSystemController_AudioCategoryNotificationParameterKey] as? String
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    /// Returns a userInfo dictionary with semi-human-readable* keys and values for AVFoundation-related
    /// key-value pairs.
    ///
    /// *Well, readable by developers.
    var ft_audioUserInfo: [String : String] {
        var mutableCopy = self
        var userInfoStrs = [String : String]()
        
        if let rawValue = mutableCopy.removeValue(forKey: AVAudioSessionInterruptionTypeKey) as? UInt, let val = AVAudioSession.InterruptionType(rawValue: rawValue) {
            userInfoStrs["interruptionType"] = val.ft_debugDescription
        }
        
        if let rawValue = mutableCopy.removeValue(forKey: AVAudioSessionRouteChangeReasonKey) as? UInt, let val = AVAudioSession.RouteChangeReason(rawValue: rawValue) {
            userInfoStrs["routeChangeReason"] = val.ft_debugDescription
        }
        
        if let value = mutableCopy.removeValue(forKey: AVAudioSessionRouteChangePreviousRouteKey) as? AVAudioSessionRouteDescription {
            userInfoStrs["previousRoute"] = value.ft_debugDescription
        }
        
        if let category = mutableCopy.removeValue(forKey: AVSystemController_AudioCategoryNotificationParameterKey) as? String {
            userInfoStrs["audioCategory"] = category
        }
        
        if let newVolume = mutableCopy.removeValue(forKey: AVSystemController_AudioVolumeNotificationParameterKey) as? Float {
            userInfoStrs["volume"] = newVolume.ft_1
        }
        
        if let volumeChangeReason = mutableCopy.removeValue(forKey: AVSystemController_AudioVolumeChangeReasonNotificationParameterKey) as? String {
            let isExplicitChange = (volumeChangeReason == AVSystemController_AudioVolumeChangeReasonExplicitVolumeChange)
            userInfoStrs["reason"] = isExplicitChange ? "Volume buttons" : volumeChangeReason
        }
        
        /// we just don't care about EU volume limits, and this key gets included in `AVSystemController_SystemVolumeDidChangeNotification`
        /// even when its value is `false`
        mutableCopy.removeValue(forKey: AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameterKey)
        
        mutableCopy.forEach { key, val in
            userInfoStrs[key.debugDescription] = "\(val)"
        }
        
        return userInfoStrs
    }
}
