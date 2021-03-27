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

public extension StringProtocol {
    var ft_int: Int? { Int(self) }
    var ft_int32: Int32? { Int32(self) }
    var ft_int64: Int64? { Int64(self) }
    var ft_seconds: TimeInterval? { ft_int.map { .init($0) } }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
    func ft_truncatingMiddle(prefixLimit: Int, suffixLimit: Int) -> String {
        guard self.count > (prefixLimit + suffixLimit) else { return String(self) }
        return "\(prefix(prefixLimit))...\(suffix(suffixLimit))"
    }
    
    /// wraps a string in parentheses
    var ft_parenthesized: String {
        "(\(String(self)))"
    }
    
    func ft_leftPadded(upTo totalLength: Int) -> String {
        let spaceCount = Swift.max(0, totalLength - self.count)
        let spaceString = String(repeating: " ", count: spaceCount)
        return spaceString + self
    }

}

#if !os(macOS)
public extension StringProtocol {
    func ft_boundingRect(with font: UIFont) -> CGRect {
        let size = CGSize(width: 1000, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        return String(self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func ft_boundingSize(with font: UIFont) -> CGSize {
        return ft_boundingRect(with: font).size
    }
}
#endif

public extension Optional where Wrapped: StringProtocol {
    /// Useful for logging optional values
    var ft_orNil: String {
        guard let val = self else { return "nil" }
        return String(val)
    }
}
