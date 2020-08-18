//
//  UIImageAssets.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIImage {

   public class var smile: UIImage {
        return UIImage(named: "smile")!
    }
    public class var cursor: UIImage {
        return UIImage(named: "cursorDefault")!
    }
    public class var cursorHand: UIImage {
        return UIImage(named: "cursorHand", in: Bundle(for: self), compatibleWith: nil)!

    }
}
