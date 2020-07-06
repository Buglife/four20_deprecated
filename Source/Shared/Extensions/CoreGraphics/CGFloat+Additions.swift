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

import CoreGraphics

public extension CGFloat {
    static let ft_pi: CGFloat = CGFloat(Float.pi)
    static let ft_halfPi: CGFloat = ft_pi / 2
    
    var ft_degreesToRadians: CGFloat { self * .pi / 180.0 }
    var ft_radiansToDegrees: CGFloat { self * 180.0 / .pi }
}

public extension Array where Element == CGFloat {
    var ft_average: CGFloat? {
        guard !isEmpty else { return nil }
        let sum = reduce(0, +)
        return sum / CGFloat(count)
    }
    
    var ft_standardDeviation: CGFloat? {
        guard !isEmpty else { return nil }
        let length = CGFloat(self.count)
        let avg = self.reduce(0, {$0 + $1}) / length
        let sumofSquaredAvgDiff = self.map { pow($0 - avg, 2.0) }.reduce(0, {$0 + $1})
        return sqrt(sumofSquaredAvgDiff / length)
    }
}

public extension Array where Element == CGFloat? {
    /// returns the max of non-nil values
    var ft_compactMax: CGFloat? { compactMap { $0 }.max() }
    
    /// returns the min of non-nil values
    var ft_compactMin: CGFloat? { compactMap { $0 }.min() }
}
