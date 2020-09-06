//
//  Bool+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Bool {
    var ft_enabledString: String { self ? "enabled" : "disabled" }
    var ft_onString: String { self ? "on" : "off" }
    var ft_succeededString: String { self ? "succeeded" : "failed" }
    var ft_yesString: String { self ? "yes" : "no" }
    var ft_openString: String { self ? "open" : "closed" }
    var ft_eyesEmoji: String { self ? "👀" : "😑" }
}
