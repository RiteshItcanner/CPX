//
//  Date+Extension.swift
//  Saudi Coupon
//
//  Created by baps on 18/12/19.
//  Copyright © 2019 Appbirds. All rights reserved.
//

import Foundation
import UIKit

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

extension Date {
    func getInterval() -> Int {
        return Int(Date().timeIntervalSince(self) * 1000)
    }
}

extension Date {
    static func getFormattedDate(string: String, formatter: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatter // "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM"
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date ?? Date())
    }

    func getFirstDateOfCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the year and month components of the current date
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        // Create a new date with the first day of the current month
        var components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components)
    }

    func getLastDateOfCurrentMonth() -> Date? {
        let lastDayComponents = DateComponents(month: 1, day: -1)
        if let firstDate = getFirstDateOfCurrentMonth() {
            return calendar.date(byAdding: lastDayComponents, to: firstDate)!
        }
        return nil
    }

    func getLastDateOfCurrentYear() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the year component of the current date
        let year = calendar.component(.year, from: currentDate)

        // Create a new date with the last day of the current year
        var components = DateComponents(year: year, month: 12, day: 31)
        return calendar.date(from: components)
    }

    func getFirstDateOfCurrentYear() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()
        return DateComponents(calendar: calendar, year: year(using: calendar)).date
    }

    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
}

extension TimeInterval {
    var milliseconds: Int {
        return Int(truncatingRemainder(dividingBy: 1) * 1000)
    }

    var seconds: Int {
        return Int(self) % 60
    }

    var minutes: Int {
        return (Int(self) / 60) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}

/* public extension UIApplication {

     func clearLaunchScreenCache() {
         do {
             try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
         } catch {
             print("Failed to delete launch screen cache: \(error)")
         }
     }

 } */

// MARK: - Appbirds

extension Date {
    /// EZSE: Initializes Date from string and format
    public init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    /// EZSE: Initializes Date from string returned from an http response, according to several RFCs
    public init? (httpDateString: String) {
        if let rfc1123 = Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        // self.init()
        return nil
    }

    /// EZSE: Converts Date to String
    public func toString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }

    /// EZSE: Converts Date to String, with format
    public func toString(format: String, isHijri: Bool = false) -> String {
        let formatter = DateFormatter()
        if isHijri {
            formatter.locale = Locale(identifier: "ar")
        }
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    public func toHijriString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    /// EZSE: Calculates how many days passed from now to date
    public func daysInBetweenDate(_ date: Date) -> Double {
        var diff = timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 86400)
        return diff
    }

    /// EZSE: Calculates how many hours passed from now to date
    public func hoursInBetweenDate(_ date: Date) -> Double {
        var diff = timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 3600)
        return diff
    }

    /// EZSE: Calculates how many minutes passed from now to date
    public func minutesInBetweenDate(_ date: Date) -> Double {
        var diff = timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 60)
        return diff
    }

    /// EZSE: Calculates how many seconds passed from now to date
    public func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }

    /// EZSE: Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        var str: String

        if components.year! >= 1 {
            components.year == 1 ? (str = "year") : (str = "years")
            return "\(String(describing: components.year)) \(str) ago"
        } else if components.month! >= 1 {
            components.month == 1 ? (str = "month") : (str = "months")
            return "\(String(describing: components.month)) \(str) ago"
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "day") : (str = "days")
            return "\(String(describing: components.day)) \(str) ago"
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "hour") : (str = "hours")
            return "\(String(describing: components.hour)) \(str) ago"
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "minute") : (str = "minutes")
            return "\(String(describing: components.minute)) \(str) ago"
        } else if components.second == 0 {
            return "Just now"
        } else {
            return "\(String(describing: components.second)) seconds ago"
        }
    }

    public func currentTimeInSeconds() -> Double {
        return Double(timeIntervalSince1970.rounded())
    }

    /*
        // EZSE: Check date if it is today
        public var isToday: Bool {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            return format.string(from: self) == format.string(from: Date())
        }

        // EZSE : Get the year from the date
        public var year: Int {
            return NSCalendar.current.component(Calendar.Component.year, from: self)
        }

        // EZSE : Get the month from the date
        public var month: Int {
            return NSCalendar.current.component(Calendar.Component.month, from: self)
        }

        // EZSE : Get the weekday from the date
        public var weekday: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }

        // EZSE : Get the month from the date
        public var monthAsString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: self)
        }

        // EZSE : Get the day from the date
        public var day: Int {
            return NSCalendar.current.component(Calendar.Component.day, from: self)
        }
     */
}

public extension Date {
    /// SwifterSwift: Day name format.
    ///
    /// - threeLetters: 3 letter day abbreviation of day name.
    /// - oneLetter: 1 letter day abbreviation of day name.
    /// - full: Full day name.
    public enum DayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }

    /// SwifterSwift: Month name format.
    ///
    /// - threeLetters: 3 letter month abbreviation of month name.
    /// - oneLetter: 1 letter month abbreviation of month name.
    /// - full: Full month name.
    public enum MonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
}

// MARK: - Properties

public extension Date {
    /// SwifterSwift: User’s current calendar.
    public var calendar: Calendar {
        return Calendar.current
    }

    /// SwifterSwift: Era.
    public var era: Int {
        return Calendar.current.component(.era, from: self)
    }

    /// SwifterSwift: Quarter.
    public var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }

    /// SwifterSwift: Week of year.
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// SwifterSwift: Week of month.
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }

    /// SwifterSwift: Year.
    public var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .year, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Month.
    public var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .month, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Day.
    public var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .day, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Weekday.
    public var weekday: Int {
        get {
            return Calendar.current.component(.weekday, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .weekday, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Hour.
    public var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .hour, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Minutes.
    public var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .minute, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Seconds.
    public var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .second, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Nanoseconds.
    public var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .nanosecond, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Milliseconds.
    public var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Check if date is in future.
    public var isInFuture: Bool {
        return self > Date()
    }

    /// SwifterSwift: Check if date is in past.
    public var isInPast: Bool {
        return self < Date()
    }

    /// SwifterSwift: Check if date is in today.
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    /// SwifterSwift: Check if date is within yesterday.
    public var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    /// SwifterSwift: Check if date is within tomorrow.
    public var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }

    /// SwifterSwift: Check if date is within a weekend period.
    public var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }

    /// SwifterSwift: Check if date is within a weekday period.
    public var isInWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }

    /// SwifterSwift: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    public var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// SwifterSwift: Nearest five minutes to date.
    public var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// SwifterSwift: Nearest ten minutes to date.
    public var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// SwifterSwift: Nearest quarter hour to date.
    public var nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// SwifterSwift: Nearest half hour to date.
    public var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// SwifterSwift: Nearest hour to date.
    public var nearestHour: Date {
        if minute >= 30 {
            return beginning(of: .hour)!.adding(.hour, value: 1)
        }
        return beginning(of: .hour)!
    }

    /// SwifterSwift: Time zone used by system.
    public var timeZone: TimeZone {
        return Calendar.current.timeZone
    }

    /// SwifterSwift: UNIX timestamp from date.
    public var unixTimestamp: Double {
        return timeIntervalSince1970
    }
}

// MARK: - Methods

public extension Date {
    /// SwifterSwift: Date by adding multiples of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    public func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// SwifterSwift: Add calendar component to date.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    public mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }

    /// SwifterSwift: Date by changing value of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of compnenet to change.
    /// - Returns: original date after changing given component to given value.
    public func changing(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(bySetting: component, value: value, of: self)
    }

    /// SwifterSwift: Data at the beginning of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    public func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))

        case .minute:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))

        case .hour:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))

        case .day:
            return Calendar.current.startOfDay(for: self)

        case .weekOfYear, .weekOfMonth:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))

        case .month:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: self))

        case .year:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: self))

        default:
            return nil
        }
    }

    /// SwifterSwift: Date at the end of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    public func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date

        case .minute:
            var date = adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .hour:
            var date = adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .day:
            var date = adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.add(.second, value: -1)
            return date

        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date

        case .month:
            var date = adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date

        default:
            return nil
        }
    }

    /// SwifterSwift: Date string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    public func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Date and time string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    public func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Check if date is in current given calendar component.
    ///
    /// - Parameter component: calendar component to check.
    /// - Returns: true if date is in current given calendar component.
    public func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// SwifterSwift: Time string from date
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    public func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    public func timeStringSort(ofStyle style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Day name from date.
    ///
    /// - Parameter Style: style of day name (default is DayNameStyle.full).
    /// - Returns: day name string (example: W, Wed, Wednesday).
    public func dayName(ofStyle style: DayNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Month name from date.
    ///
    /// - Parameter Style: style of month name (default is MonthNameStyle.full).
    /// - Returns: month name string (example: D, Dec, December).
    public func monthName(ofStyle style: MonthNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var startOfDay: Date {
            return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

// MARK: - Initializers

public extension Date {
    /// SwifterSwift: Create a new date form calendar components.
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    public init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond

        if let date = calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }

    /// SwifterSwift: Create date object from ISO8601 string.
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    public init?(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: iso8601String) {
            self = date
        } else {
            return nil
        }
    }

    /// SwifterSwift: Create new date object from UNIX timestamp.
    ///
    /// - Parameter unixTimestamp: UNIX timestamp.
    public init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }
}

extension Date {
    init(ticks: UInt64) {
        self.init(timeIntervalSince1970: Double(ticks) / 10000000 - 62135596800)
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((timeIntervalSince1970 + 62135596800) * 10000000)
    }

    func timeAgoSinceDate(numericDates: Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "moments ago"
        }
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }

    static var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    }

    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }

    func addDays(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
    func startOfMonth() -> Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return (interval?.start.toLocalTimes())! // Without toLocalTime it give last months last date
    }

    // Convert UTC (or GMT) to local time
    func toLocalTimes() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        components.day = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth())!
    }

    func startOfWeek(using calendar: Calendar = Calendar.current) -> Date? {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)
    }

    func endOfWeek(using calendar: Calendar = Calendar.current) -> Date? {
        guard let startOfWeek = startOfWeek(using: calendar) else { return nil }
        return calendar.date(byAdding: .day, value: 6, to: startOfWeek)
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
