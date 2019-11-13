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

typealias StringAttributes = [NSAttributedString.Key : Any]

protocol AttributedStringable {
    associatedtype T
    func ft_withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> T
    func ft_withAttributes(_ attributes: [NSAttributedString.Key : Any]) -> T
}

extension AttributedStringable {
    func ft_color(_ color: UIColor) -> T {
        return ft_withAttribute(.foregroundColor, color)
    }
    
    func ft_font(_ font: UIFont) -> T {
        return ft_withAttribute(.font, font)
    }
    
    func ft_stroke(width: CGFloat, color: UIColor) -> T {
        return ft_withAttributes([.strokeWidth : width, .strokeColor: color])
    }
}

extension String: AttributedStringable {
    var ft_attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    // MARK: - AttributedStringable
    
    func ft_withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> NSAttributedString {
        let attrs: [NSAttributedString.Key : Any] = [key : value]
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    func ft_withAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}

extension NSAttributedString: AttributedStringable {
    // MARK: - AttributedStringable
    
    func ft_withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> NSAttributedString {
        var attrs = attributes(at: 0, effectiveRange: nil)
        attrs[key] = value
        return NSAttributedString(string: self.string, attributes: attrs)
    }
    
    func ft_withAttributes(_ newAttributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let attrs = ft_startingAttributes.merging(newAttributes) { $1 }
        return NSAttributedString(string: self.string, attributes: attrs)
    }
    
    var ft_startingAttributes: [NSAttributedString.Key : Any] {
        return attributes(at: 0, effectiveRange: nil)
    }
}

extension Dictionary: AttributedStringable where Key == NSAttributedString.Key, Value == Any {
    static let ft_empty: [NSAttributedString.Key : Any] = [:]
    
    // MARK: - AttributedStringable
    
    func ft_withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> [NSAttributedString.Key : Any] {
        var attrs = self
        attrs[key] = value
        return attrs
    }
    
    func ft_withAttributes(_ attributes: [NSAttributedString.Key : Any]) -> [NSAttributedString.Key : Any] {
        return self.merging(attributes) { $1 }
    }
}
