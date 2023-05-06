//
//  Date+Extension.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import Foundation

extension Date {
    func appFormat() -> String {
        DateFormatter.appFormat.string(from: self)
    }
}

extension DateFormatter {
    static var appFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter
    }
}
