//
//  Noop.swift
//

/// Can be used instead of an empty closure as a syntactic sugar
/// when not using so many parentheses and underlines is preferred.
/// All passed parameters will not be used and thrown away.
///
/// # Reference
/// [NoopKit](https://github.com/mkj-is/NoopKit)
@inlinable
public func ft_noop() {}

@inlinable
public func noop<P1>(
    _: P1
) {}

@inlinable
public func noop<P1, P2>(
    _: P1,
    _: P2
) {}

@inlinable
public func noop<P1, P2, P3>(
    _: P1,
    _: P2,
    _: P3
) {}

@inlinable
public func noop<P1, P2, P3, P4>(
    _: P1,
    _: P2,
    _: P3,
    _: P4
) {}

@inlinable
public func noop<P1, P2, P3, P4, P5>(
    _: P1,
    _: P2,
    _: P3,
    _: P4,
    _: P5
) {}
