//
//  FTSKFloat.swift
//

/// macOS uses `CGFloat` throughout SceneKit, but iOS and other platforms use `Float`.
#if os(macOS)
public typealias FTSKFloat = CGFloat
#else
public typealias FTSKFloat = Float
#endif
