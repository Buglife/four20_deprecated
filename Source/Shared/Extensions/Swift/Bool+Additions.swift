//
//  Bool+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Bool {
    public var ft_enabledString: String { self ? "enabled" : "disabled" }
    public var ft_onString: String { self ? "on" : "off" }
    public var ft_succeededString: String { self ? "succeeded" : "failed" }
    public var ft_yesString: String { self ? "yes" : "no" }
    public var ft_openString: String { self ? "open" : "closed" }
    public var ft_eyesEmoji: String { self ? "👀" : "😑" }
}
