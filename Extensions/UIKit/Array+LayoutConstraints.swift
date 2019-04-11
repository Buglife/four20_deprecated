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

import UIKit

/**
 * This wizardry allows us to very easily create an array that mixes
 * both constraints and arrays of constraints, and activate them
 */
public protocol LayoutConstraintObjectOrArray {}
extension NSLayoutConstraint: LayoutConstraintObjectOrArray {}
extension Array: LayoutConstraintObjectOrArray where Element == NSLayoutConstraint {}

public extension Array where Element == LayoutConstraintObjectOrArray {
    
    /**
     * Flattens & activates an array of constraints
     */
    func ft_activate() {
        ft_flattened().ft_activate()
    }
    
    func ft_flattened() -> [NSLayoutConstraint] {
        var res = [NSLayoutConstraint]()
        
        for val in self {
            if let arr = val as? [LayoutConstraintObjectOrArray] {
                res.append(contentsOf: arr.ft_flattened())
            } else if let constraint = val as? NSLayoutConstraint {
                res.append(constraint)
            }
        }
        
        return res
    }
}
