//
//  ProcessInfo+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Foundation

public extension ProcessInfo.ThermalState {
    var ft_description: String {
        switch self {
        case .nominal: return "Nominal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        default:
            assertionFailure("Unexpected thermal state: \(self.rawValue)")
            return "Unexpected"
        }
    }
    
    var ft_emoji: String {
        switch self {
        case .nominal: return "✅"
        case .fair: return "🌀"
        case .serious: return "🌶"
        case .critical: return "⚠️"
        default:
            assertionFailure("Unexpected thermal state: \(self.rawValue)")
            return "⁉"
        }
    }
    
    var ft_emojiDescription: String {
        return "\(ft_emoji) \(ft_description)"
    }
}
