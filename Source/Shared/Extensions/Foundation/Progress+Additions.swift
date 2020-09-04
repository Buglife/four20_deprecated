//
//  Progress+Additions
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public extension Progress {
    convenience init(ft_totalUnitCount: Int64, completedUnitCount: Int64) {
        self.init(totalUnitCount: ft_totalUnitCount)
        self.completedUnitCount = completedUnitCount
    }
    
    var ft_percentString: String {
        let completed = Float(completedUnitCount)
        let total = Float(totalUnitCount)
        return (completed / total).ft_percentString()
    }
}
