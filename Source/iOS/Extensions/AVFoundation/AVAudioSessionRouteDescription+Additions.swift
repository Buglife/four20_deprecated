//
//  AVAudioSessionRouteDescription+Additions.swift
//

import AVFoundation

public extension AVAudioSessionRouteDescription {
    var ft_debugDescription: String {
        let inputStrs = inputs.map(\.ft_debugDescription).joined(separator: ", ")
        let outputStr = outputs.map(\.ft_debugDescription).joined(separator: ", ")
        return "\(inputStrs) / \(outputStr)"
    }
}

public extension AVAudioSessionPortDescription {
    var ft_debugDescription: String {
        uid
    }
}

public extension AVAudioSession.Port {
    var ft_debugDescription: String {
        if let desc = type(of: self).ft_casesAndDebugDescriptions[self] {
            return desc
        } else {
            return "unknown"
        }
    }
    
    private static let ft_casesAndDebugDescriptions: [AVAudioSession.Port : String] = {
        var result: [AVAudioSession.Port : String] = [
            .lineIn: "lineIn",
            .builtInMic: "builtInMic",
            .headsetMic: "headsetMic",
            .lineOut: "lineOut",
            .headphones: "headphones",
            .bluetoothA2DP: "bluetoothA2DP",
            .builtInReceiver: "builtInReceiver",
            .builtInSpeaker: "builtInSpeaker",
            .HDMI: "HDMI",
            .airPlay: "airPlay",
            .bluetoothLE: "bluetoothLE",
            .bluetoothHFP: "bluetoothHFP",
            .usbAudio: "usbAudio",
            .carAudio: "carAudio",
        ]
        
        if #available(iOS 14.0, *) {
            result[virtual] = "virtual"
            result[PCI] = "PCI"
            result[fireWire] = "fireWire"
            result[displayPort] = "displayPort"
            result[AVB] = "AVB"
            result[thunderbolt] = "thunderbolt"
        }
        
        return result
    }()
}
