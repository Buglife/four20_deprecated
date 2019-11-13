//
//  UICollectionView+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import UIKit

extension UICollectionView {
    func ft_registerReusableCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.ft_reuseIdentifier)
    }
    
    func ft_dequeueReusableCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.ft_reuseIdentifier, for: indexPath) as! T
    }
}

public extension UICollectionViewCell {
    static var ft_reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
