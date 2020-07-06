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

public extension UIImageView {
    func ft_constraintForAspectRatio() -> NSLayoutConstraint? {
        guard let image = self.image else { return nil }
        let aspectRatio = image.ft_aspectRatio
        return widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
    }
    
    // Why does this take an image param, rather
    // than self.image?
    // So that it can return a non-optional!
    func ft_constraintForAspectRatio(usingImage: UIImage) -> NSLayoutConstraint {
        return ft_constraint(forAspectRatio: usingImage.ft_aspectRatio)
    }
}
