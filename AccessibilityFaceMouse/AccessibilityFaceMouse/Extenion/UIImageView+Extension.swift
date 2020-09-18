//
//  UIImageView+Extension.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIImageView {

    func rotetedBy(angle: CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }

}
