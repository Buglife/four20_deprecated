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

private var ft_gestureHandlerCounter = 0

public extension UIGestureRecognizer {
    typealias FTGestureHandler = @convention(block) () -> Void
    
    func ft_addGestureHandler(forControlEvent controlEvent: UIControl.Event, block: @escaping FTGestureHandler) {
        ft_gestureHandlerCounter = ft_gestureHandlerCounter + 1
        let blockObject = unsafeBitCast(block, to: AnyObject.self)
        let implementation = imp_implementationWithBlock(blockObject)
        let selector = NSSelectorFromString("didSendGestureHandler\(ft_gestureHandlerCounter)")
        let encoding = "v@:f"
        let internalClass: AnyClass = self.classForCoder
        class_addMethod(internalClass, selector, implementation, encoding)
        addTarget(self, action: selector)
    }
}
