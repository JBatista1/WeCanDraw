//
//  MathLibs.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import Foundation
import UIKit
struct MathLibs {
    func normalize(value: CGFloat, decimalValue: CGFloat) -> CGFloat {
        let normalizeValue = floor(decimalValue * value)
        let newValue = CGFloat(normalizeValue / decimalValue)
        return newValue
    }
}
