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

public extension CGSize {
    static func *(lhs: CGSize, rhs: CGVector) -> CGSize {
        return CGSize(width: lhs.width * rhs.dx, height: lhs.height * rhs.dy)
    }
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func /(lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
    }
    
    func ft_scaledToWidth(_ newWidth: CGFloat) -> CGSize {
        let newHeight = self.height * (newWidth / self.width)
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func ft_scaledToHeight(_ newHeight: CGFloat) -> CGSize {
        let newWidth = self.width * (newHeight / self.height)
        return CGSize(width: newWidth, height: newHeight)
    }
}
