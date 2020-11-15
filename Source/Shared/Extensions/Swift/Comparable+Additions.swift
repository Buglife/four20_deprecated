//
//  Comparable+Additions.swift
//

extension Comparable {
    func ft_clamp<T: Comparable>(_ lower: T, _ upper: T) -> T? {
        guard let self = self as? T else { return nil }
        return min(max(self, lower), upper)
    }
}
