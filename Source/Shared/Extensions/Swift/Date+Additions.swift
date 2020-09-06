//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import Foundation

public extension Date {
    static func +(left: Date, right: DateComponents) -> Date? {
        return Calendar.current.date(byAdding: right, to: left)
    }
    
    static func -(left: Date, right: DateComponents) -> Date? {
        let reversed = right.ft_reversed
        return Calendar.current.date(byAdding: reversed, to: left)
    }
    
    static func -(left: Date, right: Date) -> TimeInterval {
        left.timeIntervalSince1970 - right.timeIntervalSince1970
    }
    
    var ft_debugStringInLocalTimezone: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy.MM.dd G 'at' HH:mm:ss zzz"
        return dateFormatter.string(from: self)
    }
}

public extension DateComponents {
    
    var fromNow: Date? { return ft_fromNow }
    var ft_fromNow: Date? { return Date() + self }
    
    var ago: Date? { return ft_ago }
    var ft_ago: Date? { return Date() - self }
    
    var ft_reversed: DateComponents {
        var copy = self
        
        if let nanosecond = copy.nanosecond { copy.nanosecond = -nanosecond }
        if let second = copy.second { copy.second = -second }
        if let minute = copy.minute { copy.minute = -minute }
        if let hour = copy.hour { copy.hour = -hour }
        if let day = copy.day { copy.day = -day }
        if let month = copy.month { copy.month = -month }
        if let year = copy.year { copy.year = -year }
        
        assert(copy.weekOfYear == nil, "Reversing week of year unsupported")
        assert(copy.weekOfMonth == nil, "Reversing week of month unsupported")
        assert(copy.weekday == nil, "Reversing weekday unsupported")
        assert(copy.weekdayOrdinal == nil, "Reversing weekdayOrdinal unsupported")
        assert(copy.isLeapMonth != true, "Reversing isLeapMonth unsupported")
        assert(copy.yearForWeekOfYear == nil, "Reversing yearForWeekOfYear unsupported")
        assert(copy.quarter == nil, "Reversing quarter unsupported")
        
        return copy
    }
}

public extension Int {
    var day: DateComponents { return ft_days }
    var days: DateComponents { return ft_days }
    var ft_day: DateComponents { return ft_days }
    var ft_days: DateComponents { return DateComponents(day: self) }
    
    var hour: DateComponents { return ft_hours }
    var hours: DateComponents { return ft_hours }
    var ft_hour: DateComponents { return ft_hours }
    var ft_hours: DateComponents { return DateComponents(hour: self) }
    
    var minute: DateComponents { return ft_minutes }
    var minutes: DateComponents { return ft_minutes }
    var ft_minute: DateComponents { return ft_minutes }
    var ft_minutes: DateComponents { return DateComponents(minute: self) }
    
    var second: DateComponents { return ft_seconds }
    var seconds: DateComponents { return ft_seconds }
    var ft_second: DateComponents { return ft_seconds }
    var ft_seconds: DateComponents { return DateComponents(second: self) }
}
