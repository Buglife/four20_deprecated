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

public extension SCNNode {
    /**
     * Ideal for SCNNodes with SCNPlane geometries
     */
    var ft_corners: (topLeft: SCNVector3, topRight: SCNVector3, bottomLeft: SCNVector3, bottomRight: SCNVector3, center: SCNVector3) {
        let planeNode = self
        let (min, max) = planeNode.boundingBox
        
        let bottomLeft = SCNVector3(min.x, min.y, 0)
        let topRight = SCNVector3(max.x, max.y, 0)
        let topLeft = SCNVector3(min.x, max.y, 0)
        let bottomRight = SCNVector3(max.x, min.y, 0)
        let center = SCNVector3((min.x+max.x)/2.0, (min.y+max.y)/2.0, 0)
        
        return (topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight, center: center)
    }
    
    var ft_boundingBoxWidth: FTSKFloat {
        boundingBox.max.x - boundingBox.min.x
    }
    
    var ft_boundingBoxHeight: FTSKFloat {
        boundingBox.max.y - boundingBox.min.y
    }
    
    var ft_boundingBoxSize: CGSize {
        CGSize(width: CGFloat(ft_boundingBoxWidth), height: CGFloat(ft_boundingBoxHeight))
    }
    
    // MARK: - Initializers
    
    convenience init(ft_sphere radius: CGFloat) {
        let sphere = SCNSphere(radius: radius)
        self.init(geometry: sphere)
    }
    
    convenience init(ft_plane size: CGSize) {
        let plane = SCNPlane(width: size.width, height: size.height)
        self.init(geometry: plane)
    }
    
    // MARK: - Geometry shortcuts
    
    var ft_isDoubleSided: Bool {
        get { return geometry?.ft_isDoubleSided ?? false }
        set { geometry?.ft_isDoubleSided = newValue }
    }
    
    func ft_withDoubleSided(_ doubleSided: Bool) -> SCNNode {
        ft_isDoubleSided = doubleSided
        return self
    }
}

#if !os(macOS)
public extension SCNNode {
    var ft_color: UIColor? {
        get { return geometry?.ft_color }
        set { geometry?.ft_color = newValue }
    }
    
    func ft_withColor(_ color: UIColor?) -> SCNNode {
        ft_color = color
        return self
    }
    
    func ft_withDoubleSidedColor(_ color: UIColor?) -> SCNNode {
        ft_isDoubleSided = true
        ft_color = color
        return self
    }
}
#endif
