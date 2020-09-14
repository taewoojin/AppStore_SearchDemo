//
//  Date+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation

extension Date {
    
    static func stringFromDate(date: Date, formatString: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
    
    static func dateFromISOString(string: String,
                                  timeZone: String? = nil,
                                  locale: String? = nil,
                                  dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if let localeString = locale {
            dateFormatter.locale = Locale(identifier: localeString)
        } else {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        if let timeZoneString = timeZone {
            dateFormatter.timeZone = TimeZone(abbreviation: timeZoneString)
        } else {
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        }
        
        return dateFormatter.date(from: string)
    }
}
