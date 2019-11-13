//
//  DispatchQueue+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension DispatchQueue {
    func ft_barrierAsync(work: @escaping @convention(block) () -> Void) {
        async(flags: .barrier, execute: work)
    }
    
    func ft_barrierSync(work: @convention(block) () -> Void) {
        sync(flags: .barrier, execute: work)
    }
    
    func ft_barrierSync<T>(work: () -> T) -> T {
        return sync(flags: .barrier, execute: work)
    }
}
