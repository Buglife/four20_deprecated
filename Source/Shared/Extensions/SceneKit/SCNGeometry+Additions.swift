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

import SceneKit

public extension SCNGeometry {
    var ft_isDoubleSided: Bool {
        get {
            return firstMaterial?.isDoubleSided ?? false
        }
        set {
            firstMaterial?.isDoubleSided = newValue
        }
    }
    
    var ft_firstMaterialContents: Any? {
        get { firstMaterial?.diffuse.contents }
        set { firstMaterial?.diffuse.contents = newValue }
    }
}

#if !os(macOS)
public extension SCNGeometry {
    var ft_color: UIColor? {
        get { ft_firstMaterialContents as? UIColor }
        set { ft_firstMaterialContents = newValue }
    }
    
    var ft_image: UIImage? {
        get { ft_firstMaterialContents as? UIImage }
        set { ft_firstMaterialContents = newValue }
    }
}
#endif
