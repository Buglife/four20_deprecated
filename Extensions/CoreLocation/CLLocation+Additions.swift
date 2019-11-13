//
//  CLLocation+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreLocation

typealias SpeedMPH = Double

extension CLLocation {
    var speedMPH: SpeedMPH {
        return speed.ft_speedToMPH
    }
}

extension Double {
    var ft_speedToMPH: SpeedMPH {
        return self * 2.23694
    }
}

extension SpeedMPH {
    var ft_speedToMetersPerSecond: CLLocationSpeed {
        return self / 2.23694
    }
}
