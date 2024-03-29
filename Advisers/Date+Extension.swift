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
    
    func logFileFormat() -> String {
        DateFormatter.logFileFormat.string(from: self)
    }
    
    func logTextFormat() -> String {
        DateFormatter.logTextFormat.string(from: self)
    }
    
    func hourToSecondFormat() -> String {
        DateFormatter.hourToSecondFormat.string(from: self)
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
    
    static var logFileFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter
    }
    
    static var logTextFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter
    }
    
    
    static var hourToSecondFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter
    }
}
