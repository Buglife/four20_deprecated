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

#if !os(macOS)
import UIKit
#endif

/*
 * Provides common functions across CGPoint, CGSize and CGVector
 */
public protocol CGStruct2D {
    var ft_x: CGFloat { get }
    var ft_y: CGFloat { get }
    init(ft_x: CGFloat, ft_y: CGFloat)
}

extension CGPoint: CGStruct2D {
    public var ft_x: CGFloat { get { return x } }
    public var ft_y: CGFloat { get { return y } }
    
    public init(ft_x: CGFloat, ft_y: CGFloat) {
        self.init(x: ft_x, y: ft_y)
    }
}

extension CGSize: CGStruct2D {
    public var ft_x: CGFloat { get { return width } }
    public var ft_y: CGFloat { get { return height } }
    
    public init(ft_x: CGFloat, ft_y: CGFloat) {
        self.init(width: ft_x, height: ft_y)
    }
}

extension CGVector: CGStruct2D {
    public var ft_x: CGFloat { get { return dx } }
    public var ft_y: CGFloat { get { return dy } }
    
    public init(ft_x: CGFloat, ft_y: CGFloat) {
        self.init(dx: ft_x, dy: ft_y)
    }
}

public extension CGStruct2D {
    static func *<T: CGStruct2D>(lhs: T, rhs: CGStruct2D) -> T {
        return T(ft_x: lhs.ft_x * rhs.ft_x, ft_y: lhs.ft_y * rhs.ft_y)
    }
    
    static func +<T: CGStruct2D>(lhs: T, rhs: CGStruct2D) -> T {
        return T(ft_x: lhs.ft_x + rhs.ft_x, ft_y: lhs.ft_y + rhs.ft_y)
    }
    
    static func -<T: CGStruct2D>(lhs: T, rhs: CGStruct2D) -> T {
        return T(ft_x: lhs.ft_x - rhs.ft_x, ft_y: lhs.ft_y - rhs.ft_y)
    }
}

// Multiplies any [CGPoint, CGSize, CGVector] by any [Float, Double, CGFloat]
public func *<T: CGStruct2D, U: BinaryFloatingPoint>(lhs: T, rhs: U) -> T {
    let frhs = CGFloat(rhs)
    return T(ft_x: lhs.ft_x * frhs, ft_y: lhs.ft_y * frhs)
}

public func /<T: CGStruct2D, U: BinaryFloatingPoint>(lhs: T, rhs: U) -> T {
    let frhs = CGFloat(rhs)
    return T(ft_x: lhs.ft_x / frhs, ft_y: lhs.ft_y / frhs)
}
