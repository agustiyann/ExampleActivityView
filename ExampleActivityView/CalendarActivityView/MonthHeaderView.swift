//
//  MonthHeaderView.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import UIKit

class MonthHeaderView: UIStackView {
    
    private let config: CalendarActivityConfig
    
    init(config: CalendarActivityConfig) {
        self.config = config
        super.init(frame: .zero)
        
        alignment = .center
        axis = .horizontal
        distribution = .fillProportionally
        spacing = 0
    }
    
    required init(coder: NSCoder) {
        fatalError("no storyboard implementation, should not enter here")
    }
    
    func build(headers: [(month: Int, width: CGFloat)]) {
        DispatchQueue.main.async {
            self.removeAllArrangedSubviews()
            for header in headers {
                let monthText = self.config.monthStrings[header.month - 1]
                self.append(text: monthText, width: header.width)
            }
        }
    }
    
    private func append(text: String, width: CGFloat) {
        let label = UILabel()
        label.font = config.monthFont
        label.text = text
        label.textColor = config.monthColor
        label.backgroundColor = config.backgroundColor
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        addArrangedSubview(label)
    }
}
