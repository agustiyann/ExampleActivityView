//
//  CalendarActivityViewCell.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import UIKit

class CalendarActivityViewCell: UICollectionViewCell {
    
    var config: CalendarActivityConfig! {
        didSet {
            backgroundColor = config.backgroundColor
        }
    }
    
    var itemColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let cornerRadius = config.itemCornerRadius
        let maxCornerRadius = min(bounds.width, bounds.height) * 0.5
        let path = UIBezierPath(roundedRect: rect, cornerRadius: min(cornerRadius, maxCornerRadius))
        itemColor.setFill()
        path.fill()
        guard isSelected, config.allowItemSelection else { return }
        config.selectedItemBorderColor.setStroke()
        path.lineWidth = config.selectedItemBorderLineWidth
        path.stroke()
    }
}
