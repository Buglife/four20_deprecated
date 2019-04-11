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
}

extension AttributedStringable {
    func ft_color(_ color: UIColor) -> T {
        return ft_withAttribute(.foregroundColor, color)
    }
    
    func ft_font(_ font: UIFont) -> T {
        return ft_withAttribute(.font, font)
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
}

extension NSAttributedString: AttributedStringable {
    // MARK: - AttributedStringable
    
    func ft_withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> NSAttributedString {
        var attrs = attributes(at: 0, effectiveRange: nil)
        attrs[key] = value
        return NSAttributedString(string: self.string, attributes: attrs)
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
}
