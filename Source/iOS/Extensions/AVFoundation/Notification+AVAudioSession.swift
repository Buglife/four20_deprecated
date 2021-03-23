//
//  Notification+AVAudioSession.swift
//

import AVFoundation

public extension Notification {
    
    /// - Returns: A debug description that assumes the notification is one of those related to `AVAudioSession`.
    /// - SeeAlso: [AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession)
    var ft_audioSessionDebugDescription: String {
        let readableName = readable(name.rawValue)
        
        if let userInfoStr = ft_audioSessionUserInfoString {
            return "\(readableName) | \(userInfoStr)"
        } else {
            return readableName
        }
    }
    
    var ft_audioSessionUserInfoString: String? {
        guard var userInfo = self.userInfo else { return nil }
        var userInfoStrs = [String : String]()
        
        if let rawValue = userInfo.removeValue(forKey: AVAudioSessionInterruptionTypeKey) as? UInt, let val = AVAudioSession.InterruptionType(rawValue: rawValue) {
            userInfoStrs[AVAudioSessionInterruptionTypeKey] = val.ft_debugDescription
        }
        
        if let rawValue = userInfo.removeValue(forKey: AVAudioSessionRouteChangeReasonKey) as? UInt, let val = AVAudioSession.RouteChangeReason(rawValue: rawValue) {
            userInfoStrs[AVAudioSessionRouteChangeReasonKey] = val.ft_debugDescription
        }
        
        if let value = userInfo.removeValue(forKey: AVAudioSessionRouteChangePreviousRouteKey) as? AVAudioSessionRouteDescription {
            userInfoStrs[AVAudioSessionRouteChangePreviousRouteKey] = value.ft_debugDescription
        }
        
        userInfo.forEach { key, val in
            userInfoStrs[key.debugDescription] = "\(val)"
        }
        
        let pairs: [String] = userInfoStrs.keys.sorted().reversed().map { key in
            let rawVal = userInfoStrs[key] ?? "nil"
            let length = max(rawVal.count, 14)
            let val = rawVal.padding(toLength: length, withPad: " ", startingAt: 0)
            return "\(readable(key)): \(val)"
        }
        guard !pairs.isEmpty else { return nil }
        return pairs.joined(separator: ", ")
    }
    
    // MARK: - User info
    
    var ft_audioSessionInterruptionType: AVAudioSession.InterruptionType? {
        guard let val = userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt else { return nil }
        return AVAudioSession.InterruptionType(rawValue: val)
    }
    
    var ft_audioSessionRouteChangeReason: AVAudioSession.RouteChangeReason? {
        guard let val = userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt else { return nil }
        return AVAudioSession.RouteChangeReason(rawValue: val)
    }
    
    var ft_audioSessionRouteChangePreviousRoute: AVAudioSessionRouteDescription? {
        userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
    }
}

fileprivate func readable(_ val: String) -> String {
    switch val {
    case AVAudioSession.interruptionNotification.rawValue:
        return "interruptionNotification"
    case AVAudioSession.routeChangeNotification.rawValue:
        return "routeChangeNotification"
    case AVAudioSession.mediaServicesWereResetNotification.rawValue:
        return "mediaServicesWereResetNotification"
    case AVAudioSession.mediaServicesWereLostNotification.rawValue:
        return "mediaServicesWereLostNotification"
    case AVAudioSessionRouteChangeReasonKey:
        return "routeChangeReason"
    case AVAudioSessionRouteChangePreviousRouteKey:
        return "previousRoute"
    case AVAudioSessionInterruptionTypeKey:
        return "interruptionType"
    default:
        return val
    }
}
