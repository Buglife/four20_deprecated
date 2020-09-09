//
//  UIViewOrUILayoutGuide
//  Copyright © 2020 Observant. All rights reserved.
//

import UIKit

public protocol UIViewOrUILayoutGuide {
    var superview: UIView? { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: UIViewOrUILayoutGuide {}
extension UILayoutGuide: UIViewOrUILayoutGuide {
    public var superview: UIView? { owningView }
}

public extension UIViewOrUILayoutGuide {
    func ftc_aligningTop(_ otherView: UIViewOrUILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        topAnchor.constraint(equalTo: otherView.topAnchor, constant: constant)
    }
    
    func ftc_aligningBottom(_ otherView: UIViewOrUILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: constant)
    }
    
    func ftc_aligningLeading(_ otherView: UIViewOrUILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: constant)
    }
    
    func ftc_aligningTrailing(_ otherView: UIViewOrUILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: constant)
    }
    
    func ftc_aligningWidth(_ otherView: UIViewOrUILayoutGuide, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        widthAnchor.constraint(equalTo: otherView.widthAnchor, multiplier: multiplier, constant: constant)
    }
    
    func ftc_aligningHeight(_ otherView: UIViewOrUILayoutGuide, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        heightAnchor.constraint(equalTo: otherView.heightAnchor, multiplier: multiplier, constant: constant)
    }
    
    func ftc_aligningCenterX(_ otherView: UIViewOrUILayoutGuide) -> NSLayoutConstraint {
        centerXAnchor.constraint(equalTo: otherView.centerXAnchor)
    }
    
    func ftc_aligningCenterY(_ otherView: UIViewOrUILayoutGuide) -> NSLayoutConstraint {
        centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
    }
    
    func ftc_centeredIn(_ otherView: UIViewOrUILayoutGuide) -> [NSLayoutConstraint] {
        [ftc_aligningCenterX(otherView), ftc_aligningCenterY(otherView)]
    }
    
    func ftc_withWidth(_ constant: CGFloat) -> NSLayoutConstraint {
        widthAnchor.constraint(equalToConstant: constant)
    }
    
    func ftc_withHeight(_ constant: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(equalToConstant: constant)
    }
    
    func ftc_withAspectRatio(_ aspectRatio: CGFloat) -> NSLayoutConstraint {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
    }
    
    func ftc_rightOf(_ otherView: UIViewOrUILayoutGuide, padding: CGFloat = 0) -> NSLayoutConstraint {
        leadingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: padding)
    }
    
    func ftc_leftOf(_ otherView: UIViewOrUILayoutGuide, padding: CGFloat = 0) -> NSLayoutConstraint {
        trailingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: -padding)
    }
    
    func ftc_below(_ otherView: UIViewOrUILayoutGuide, padding: CGFloat = 0) -> NSLayoutConstraint {
        topAnchor.constraint(equalTo: otherView.bottomAnchor, constant: padding)
    }
    
    func ftc_above(_ otherView: UIViewOrUILayoutGuide, padding: CGFloat = 0) -> NSLayoutConstraint {
        bottomAnchor.constraint(equalTo: otherView.topAnchor, constant: -padding)
    }
    
    func ftc_aligning(_ attributes: [NSLayoutConstraint.Attribute], to otherItem: UIViewOrUILayoutGuide) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []
        
        for attr in attributes {
            let constraint = NSLayoutConstraint(item: self, attribute: attr, relatedBy: .equal, toItem: otherItem, attribute: attr, multiplier: 1, constant: 0)
            results.append(constraint)
        }
        
        return results
    }
    
    func ftc_aligningFrame(_ anItem: UIViewOrUILayoutGuide? = nil, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let item: UIViewOrUILayoutGuide = anItem ?? self.superview else {
            assertionFailure("must provide another item, or add this to a superview first")
            return []
        }
        
        return [
            ftc_aligningTop(item, constant: inset.top),
            ftc_aligningLeading(item, constant: inset.left),
            ftc_aligningTrailing(item, constant: -inset.right),
            ftc_aligningBottom(item, constant: -inset.bottom)
        ]
    }
    
    func ftc_aligningFrame(_ anItem: UIViewOrUILayoutGuide? = nil, constant: CGFloat) -> [NSLayoutConstraint] {
        let inset = UIEdgeInsets(top: constant, left: constant, bottom: -constant, right: -constant)
        return ftc_aligningFrame(anItem, inset: inset)
    }
    
    func ftc_square(withSize size: CGFloat) -> [NSLayoutConstraint] {
        [widthAnchor.constraint(equalToConstant: size), heightAnchor.constraint(equalToConstant: size)]
    }
    
    func ftc_square(withSize anchor: NSLayoutDimension, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [widthAnchor.constraint(equalTo: anchor, multiplier: multiplier), heightAnchor.constraint(equalTo: widthAnchor)]
    }
}

