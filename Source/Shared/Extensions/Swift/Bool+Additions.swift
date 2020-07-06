//
//  Bool+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Bool {
    var ft_enabledString: String {
        return self ? "enabled" : "disabled"
    }
    
    var ft_onString: String {
        return self ? "on" : "off"
    }
    
    var ft_succeededString: String {
        return self ? "succeeded" : "failed"
    }
}
