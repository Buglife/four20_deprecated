//
//  AVAudioSessionRouteDescription+Additions.swift
//

import AVFoundation

public extension AVAudioSessionRouteDescription {
    var ft_debugDescription: String {
        let inputStrs = inputs.map(\.portName).joined(separator: ", ")
        let outputStr = outputs.map(\.portName).joined(separator: ", ")
        return "\(inputStrs) / \(outputStr)"
    }
}
