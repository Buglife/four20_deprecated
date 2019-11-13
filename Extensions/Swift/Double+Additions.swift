//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import Swift

public extension Double {
    var ft_1: String {
        return ft_format(1)
    }
    
    var ft_2: String {
        return ft_format(2)
    }
    
    func ft_format(_ fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = fractionDigits
        let num = NSNumber(value: self)
        return formatter.string(from: num) ?? "\(self)"
    }
    
    var ft_toIntegerPercent: Int {
        return Int(self * 100.0)
    }
    
    var ft_degreesToRadians: Double {
        return self * .pi / 180
    }
    
    var ft_radiansToDegrees: Double {
        return self * 180 / .pi
    }
}

public extension Array where Element == Double {
    var ft_median: Double? {
        return self.sorted(by: <)[self.count / 2]
    }
    
    var ft_average: Double? {
        guard !isEmpty else { return nil }
        let sum = Double(reduce(0, +))
        return sum / Double(count)
    }
}

public extension Array where Element == Double? {
    var ft_average: Double? {
        return compactMap { $0 }.ft_average
    }
}