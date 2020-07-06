//
//  CMTime+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreMedia

public extension CMTime {
    var ft_debugDescription: String {
        if self.value == 0 {
            return "\(self.value) / \(self.timescale)"
        }
        let denominator = self.timescale / Int32(self.value)
        return "1 / \(denominator)"
    }
}
