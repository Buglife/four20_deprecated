//
//  GenericProgress
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

/// Similar to Foundation's `Progress` type, with two improvements:
///
/// 1. Conforms to `Codable`
/// 2. Is a generic, so it can support things like time-based-progress
public struct GenericProgress<T : ProgressUnit>: Codable {
    public let completed: T
    public let total: T
    public var remaining: T { total - completed }
    
    public var fractionCompleted: Double {
        guard total != 0 else { return 0 }
        return completed.ft_double / total.ft_double
    }
    
    // MARK: - Initializer
    
    public init(completed: T, total: T) {
        self.completed = completed
        self.total = total
    }
}

public extension GenericProgress where T : BinaryInteger {
    public init(progress: Progress) {
        self.completed = T(progress.completedUnitCount)
        self.total = T(progress.totalUnitCount)
    }
}

public protocol ProgressUnit: Numeric, Codable {
    var ft_double: Double { get }
}

extension Int: ProgressUnit {
    public var ft_double: Double { Double(self) }
}
extension TimeInterval: ProgressUnit {
    public var ft_double: Double { Double(self) }
}

