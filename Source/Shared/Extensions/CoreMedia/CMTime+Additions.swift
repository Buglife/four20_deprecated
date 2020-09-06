//
//  CMTime+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreMedia

public extension CMTime {
    var ft_denominator: Int32? {
        guard value != 0 else { return nil }
        return timescale / Int32(value)
    }
    
    var ft_debugDescription: String {
        guard let denominator = ft_denominator else {
            return "\(self.value) / \(self.timescale)"
        }
        
        return "1 / \(denominator)"
    }
}
