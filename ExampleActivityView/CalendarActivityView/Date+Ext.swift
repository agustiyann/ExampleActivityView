//
//  Date+Ext.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import Foundation
import UIKit

extension Date {
    
    static func dateOf(_ year:Int, _ month: Int, _ day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }
    
    static func fromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}
