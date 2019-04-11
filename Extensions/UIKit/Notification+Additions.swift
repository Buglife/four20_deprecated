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

extension Notification {
    struct KeyboardInfo {
        let duration: TimeInterval
        let animationOptions: UIView.AnimationOptions
        let bottomConstraintConstant: CGFloat
    }
    
    func ft_keyboardInfo(view: UIView) -> KeyboardInfo? {
        guard let userInfo = self.userInfo else { return nil }
        guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return nil }
        guard let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
        guard let rawAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return nil }
        let animationOptions = UIView.AnimationOptions(rawValue: rawAnimationCurve)
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let bottomConstraintConstant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        return KeyboardInfo(duration: duration, animationOptions: animationOptions, bottomConstraintConstant: bottomConstraintConstant)
    }
}
