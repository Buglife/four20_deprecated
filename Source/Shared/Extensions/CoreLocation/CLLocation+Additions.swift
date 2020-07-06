//
//  CLLocation+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreLocation

public typealias SpeedMPH = Double

public extension CLLocation {
    var speedMPH: SpeedMPH {
        return speed.ft_speedToMPH
    }
}

public extension Double {
    var ft_speedToMPH: SpeedMPH {
        return self * 2.23694
    }
}

public extension SpeedMPH {
    var ft_speedToMetersPerSecond: CLLocationSpeed {
        return self / 2.23694
    }
}
