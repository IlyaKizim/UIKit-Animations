//
//  ButtonCust.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class ButtonCast: UIButton {

    override func tintColorDidChange() {
        super.tintColorDidChange()
        switch tintAdjustmentMode {
        case .dimmed: setTitleColor(.systemGray, for: .normal)
        default:
            setTitleColor(.systemBlue, for: .normal)
        }
    }
}
