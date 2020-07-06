//
//  Notification+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
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
