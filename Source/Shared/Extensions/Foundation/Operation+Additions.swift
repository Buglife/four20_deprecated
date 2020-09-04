//
//  OperationQueue+Additions.swift
//  Copyright © 2020 Observant. All rights reserved.
//

import Foundation

public extension OperationQueue {
    convenience init(ft_maxConcurrentOperationCount: Int) {
        self.init()
        maxConcurrentOperationCount = ft_maxConcurrentOperationCount
    }
    
    /// Attempts to check that an operation queue is empty before adding a block operation.
    /// Note that this is does *not* guarantee "correctness" in that if this method gets called
    /// concurrently, it's possible for the operationCount check to pass for both callers,
    /// thereby adding 2 operations. Do not use this method if you need to guarantee that
    /// the operationQueue is empty prior to adding your operation.
    ///
    /// You generally only want to use this when you're adding the same block to a queue
    /// in a tight loop, and can afford to occassionally discard a block, but it's also not the
    /// end of the world if two blocks get added.
    func ft_addOperationIfEmtpyish(_ block: @escaping () -> Void) {
        guard operationCount == 0 else { return }
        addOperation(block)
    }
    
    /// `OperationQueue.progress` doesn't factor in completed operations
    func ft_progress(withTotal total: Int) -> Progress {
        let remainingCount = Int64(operationCount)
        let totalCount = Int64(total)
        let completedCount = totalCount - remainingCount
        return .init(ft_totalUnitCount: totalCount, completedUnitCount: completedCount)
    }
}
