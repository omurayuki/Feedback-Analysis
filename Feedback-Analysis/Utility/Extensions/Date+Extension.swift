import Foundation

extension Date {
    static func dateFromString(_ string: String, format: String? = nil) -> Date? {
        let dateFormat = format != nil ? format! : "yyyy.MM.dd"
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        return formatter.date(from: string)
    }
    
    static func stringFromDate(_ date: Date, format: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale.current
        formatter.dateFormat = format ?? "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    var day: Int {
        return parse(format: "dd")
    }
    
    var month: Int {
        return parse(format: "MM")
    }
    
    var year: Int {
        return parse(format: "yyyy")
    }
    
    var timeInterval: UInt64 {
        let nineHours: Double = 9 * 60 * 60 * 1000
        return UInt64(timeIntervalSince1970 * 1000 + nineHours)
    }
    
    private func parse(format: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return Int(formatter.string(from: self))!
    }
}
