//
//  Date+Extension.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 6.02.2023.
//

import Foundation

extension Date {

    static func date(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: dateString)
    }
    
    var customDateWithHour: String {
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd - HH:mm";
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self as Date)
    }
    
    var customDate: String {
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy.MM.dd";
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self as Date)
    }

}
