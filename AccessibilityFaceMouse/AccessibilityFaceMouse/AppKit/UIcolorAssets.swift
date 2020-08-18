//
//  UIcolorAssets.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIColor {

    public static var blueApp: UIColor {
        let color = UIColor(named: "blueApp") ?? #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        return color
    }
    
    public static var greenApp: UIColor {
        let color = UIColor(named: "greenApp") ?? #colorLiteral(red: 0.1490196078, green: 0.8901960784, blue: 0.6901960784, alpha: 1)
        return color
    }

    public static var pinkApp: UIColor {
        let color = UIColor(named: "pinkApp") ?? #colorLiteral(red: 0.968627451, green: 0.5647058824, blue: 0.9529411765, alpha: 1)
        return color
    }
}
