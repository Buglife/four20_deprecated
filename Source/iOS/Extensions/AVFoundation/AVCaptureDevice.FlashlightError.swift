//
//  AVCaptureDeviceFlashlightError.swift
//

import AVFoundation

@available(macCatalyst 14.0, *)
public extension AVCaptureDevice {
    enum FlashlightError: Swift.Error, CustomDebugStringConvertible {
        case noCaptureDevice // what the fuck
        case torchNotAvailable
        case wrapped(Swift.Error)
        
        // MARK: - Accessors
        
        public var caseDescription: String {
            switch self {
            case .noCaptureDevice:
                return "noCaptureDevice"
            case .torchNotAvailable:
                return "torchNotAvailable"
            case .wrapped(let error):
                return "wrapped(\(error.localizedDescription))"
            }
        }
        
        public var debugDescription: String {
            "FlashlightError.\(caseDescription))"
        }
    }
}
