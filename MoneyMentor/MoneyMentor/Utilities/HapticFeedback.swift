//
//  HapticFeedback.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 15.10.2024.
//

import SwiftUI

class HapticFeedback {
    // iOS implementation
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    static func playSelection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
