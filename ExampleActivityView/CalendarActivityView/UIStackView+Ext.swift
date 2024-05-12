//
//  UIStackView+Ext.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import Foundation
import UIKit

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
