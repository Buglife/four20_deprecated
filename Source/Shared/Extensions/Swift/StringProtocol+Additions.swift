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
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
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