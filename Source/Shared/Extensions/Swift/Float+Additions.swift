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

public extension Float {
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
    
    var ft_metersToInches: Float {
        return self * 39.37
    }
    
    var ft_inchesToMeters: Float {
        return self / 39.37
    }
    
    var ft_degreesToRadians: Float {
        return self * .pi / 180
    }
    
    var ft_radiansToDegrees: Float {
        return self * 180 / .pi
    }
}

public extension Array where Element == Float {
    var ft_average: Float? {
        guard !isEmpty else { return nil }
        let sum = reduce(0, +)
        return sum / Float(count)
    }
    
    var ft_standardDeviation: Float? {
        let length = Float(self.count)
        guard length > 0 else { return nil }
        let avg = self.reduce(0, {$0 + $1}) / length
        let sumofSquaredAvgDiff = self.map { pow($0 - avg, 2.0) }.reduce(0, {$0 + $1})
        return sqrt(sumofSquaredAvgDiff / length)
    }
}
