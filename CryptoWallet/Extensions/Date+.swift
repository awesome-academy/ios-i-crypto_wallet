//
//  Date+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/16/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

extension Date {
    static func convertTimeStampToDate(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+7")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date)
    }
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+7")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date)
    }
}
