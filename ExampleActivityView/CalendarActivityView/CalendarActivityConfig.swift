//
//  CalendarActivityConfig.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import UIKit

struct CalendarActivityConfig {
    var backgroundColor: UIColor = .white
    var contentRightInset: CGFloat = 60
    
    // calendar day item
    var itemSide: CGFloat = 12
    var itemCornerRadius: CGFloat = 2
    var allowItemSelection: Bool = false
    var selectedItemBorderColor: UIColor = .black
    var selectedItemBorderLineWidth: CGFloat = 2
    var interitemSpacing: CGFloat = 4
    var lineSpacing: CGFloat = 4
    
    // calendar weekday
    var weekDayColor: UIColor = .black
    var weekDayStrings: [String] = DateFormatter().shortWeekdaySymbols.map{ $0.capitalized }
    var weekDayFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    var weekDayWidth: CGFloat = 30
    
    // calendar month header
    var monthColor: UIColor = .black
    var monthStrings: [String] = DateFormatter().monthSymbols
    var monthFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    var monthHeight: CGFloat = 20
    
    init(){}
}
