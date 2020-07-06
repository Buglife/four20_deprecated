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

public extension UIImage {
    var ft_aspectRatio: CGFloat {
        return size.width / size.height
    }
    
    func ft_resized(_ newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let rect = CGRect(origin: .zero, size: newSize)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func ft_masked(imageMask: UIImage) -> UIImage? {
        guard let flippedSelf = self.ft_flippedHorizontally else { return nil }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let maskCgImage = imageMask.cgImage else { return nil }
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: maskCgImage)
        flippedSelf.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
    
    var ft_flippedHorizontally: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
    
    func ft_rotated(byDegrees degrees: Double) -> UIImage? {
        let radians = CGFloat(degrees * .pi) / 180.0 as CGFloat
        let rotatedSize = self.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let cgImage = self.cgImage else { return nil }
        guard let bitmap = UIGraphicsGetCurrentContext() else { return nil }
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: radians)
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(cgImage, in: CGRect.init(x: -self.size.width / 2, y: -self.size.height / 2 , width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
    var ft_patternColor: UIColor {
        return UIColor(patternImage: self)
    }
}
