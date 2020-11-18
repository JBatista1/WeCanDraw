//
//  MathLibs.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import Foundation
import UIKit
public struct MathLibs {
    static func normalize(value: CGFloat, decimalValue: CGFloat) -> CGFloat {
        let normalizeValue = floor(decimalValue * value)
        let newValue = CGFloat(normalizeValue / decimalValue)
        return newValue
    }
    static func conrteFirstNumber(inValue value: CGFloat, decimalValue: CGFloat) -> Int {
        return Int(decimalValue * value)
    }

}
