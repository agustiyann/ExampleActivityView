//
//  ViewController.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let calendar = Calendar.current
    private lazy var twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
    private lazy var oneDayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
    private lazy var today = calendar.date(byAdding: .day, value: 0, to: Date())!
    private let aug_23_2023 = Date.fromString("2023-08-23", format: "yyyy-MM-dd")!
    
    private lazy var highlightedDates: [Date] = [twoDaysAgo, oneDayAgo, today, aug_23_2023]
    
    private let calendarActivityView: CalendarActivityView = {
        let startDate = Date().addingTimeInterval(-365 * 24 * 60 * 60)
        var config = CalendarActivityConfig()
        config.contentRightInset = 16
        let view = CalendarActivityView(config: config, startDate: startDate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectedDateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "You selected:"
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        return view
    }()
    
    private let highlightedDatesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarActivityView.delegate = self
        
        highlightedDatesLabel.text = "Highlighted Dates:\n1. Today\n2. One day ago\n3. Two days ago\n4. 23 Aug 2023"
        
        view.addSubview(calendarActivityView)
        view.addSubview(selectedDateLabel)
        view.addSubview(highlightedDatesLabel)
        
        NSLayoutConstraint.activate([
            calendarActivityView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarActivityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarActivityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            selectedDateLabel.topAnchor.constraint(equalTo: calendarActivityView.bottomAnchor, constant: 16),
            selectedDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            highlightedDatesLabel.topAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor, constant: 16),
            highlightedDatesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            highlightedDatesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }


}

extension ViewController: CalendarActivityViewDelegate {
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return .blue.withAlphaComponent(0.1)
        }

        if highlightedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return .black
        } else {
            return .blue.withAlphaComponent(0.1)
        }
    }
    
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        // do something here
        print(day, month, year)
        selectedDateLabel.text = "You selected: \(day)-\(month)-\(year)"
    }
    
    func finishLoadCalendar() {
        calendarActivityView.scrollTo(date: today, at: .right, animated: false)
    }
}
