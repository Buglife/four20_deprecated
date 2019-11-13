//
//  ISO8601DateFormatter+Additions.swift
//

extension ISO8601DateFormatter {
    static func ft_dateFormatterForRailsAPI() -> ISO8601DateFormatter {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoDateFormatter
    }
}

extension DateFormatter {
    static func ft_iso8601Full() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
