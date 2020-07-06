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

public extension BinaryFloatingPoint {
    var ft_metersToInches: Self {
        return self * 39.37
    }
    
    var ft_inchesToMeters: Self {
        return self / 39.37
    }
}

public extension BinaryFloatingPoint where Self: CVarArg {
    var ft_1: String {
        return String(format: "%.1f", self)
    }
    
    var ft_2: String {
        return String(format: "%.2f", self)
    }
}

public extension Collection where Iterator.Element: BinaryFloatingPoint {
    var ft_average: Iterator.Element? {
        guard !isEmpty else { return nil }
        let sum = reduce(0, +)
        return sum / Iterator.Element(count)
    }
    
    var ft_standardDeviation: Iterator.Element? {
        let length = Iterator.Element(count)
        guard length > 0 else { return nil }
        let avg = reduce(0, {$0 + $1}) / length
        let sumofSquaredAvgDiff = Iterator.Element(map { pow(Double($0 - avg), 2.0) }.reduce(0, {$0 + $1}))
        return sqrt(sumofSquaredAvgDiff / length)
    }
}
