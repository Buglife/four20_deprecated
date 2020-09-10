//
//  VNClassificationObservation+Additions.swift
//
//

import Vision

public extension VNClassificationObservation {}

extension Array where Element == VNClassificationObservation {
    /// returns the first VNClassificationObservation found with the given identifier
    public func ft_first(_ identifier: String) -> VNClassificationObservation? {
        first(where: { $0.identifier == identifier })
    }
}
