//
//  AVAudioSessionRouteDescription+Additions.swift
//

import AVFoundation

public extension AVAudioSessionRouteDescription {
    var ft_debugDescription: String {
        let inputStrs = inputs.map { $0.portName }.joined(separator: ", ")
        let outputStr = outputs.map(\.portName).joined(separator: ", ")
        return "\(inputStrs) / \(outputStr)"
    }
}
