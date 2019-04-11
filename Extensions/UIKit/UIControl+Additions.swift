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

private var ft_buttonControlEventHandlerCounter = 0

public extension UIControl {
    typealias FTControlEventHandler = @convention(block) () -> Void
    
    func ft_addControlEventHandler(forControlEvent controlEvent: UIControl.Event, block: @escaping FTControlEventHandler) {
        ft_buttonControlEventHandlerCounter = ft_buttonControlEventHandlerCounter + 1
        let blockObject = unsafeBitCast(block, to: AnyObject.self)
        let implementation = imp_implementationWithBlock(blockObject)
        let selector = NSSelectorFromString("didSendControlEvent\(ft_buttonControlEventHandlerCounter)")
        let encoding = "v@:f"
        let internalClass: AnyClass = self.classForCoder
        class_addMethod(internalClass, selector, implementation, encoding)
        addTarget(self, action: selector, for: controlEvent)
    }
}
