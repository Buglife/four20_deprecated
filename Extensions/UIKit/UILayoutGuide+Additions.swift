//
//  UILayoutGuide+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

public extension UILayoutGuide {
    func ft_constraintsToMatchFrameOfView(_ view: UIView) -> [NSLayoutConstraint] {
        return [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}
