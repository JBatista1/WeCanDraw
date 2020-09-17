//
//  MovimenteLimit.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 16/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

public struct MovimenteLimit {
    let top: CGFloat
    let botton: CGFloat
    let left: CGFloat
    let right: CGFloat

    public init (top: CGFloat, botton: CGFloat, left: CGFloat, right: CGFloat) {
        self.top = top
        self.botton = botton
        self.left = left
        self.right = right
    }

}
