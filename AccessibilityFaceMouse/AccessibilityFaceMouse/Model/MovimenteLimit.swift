//
//  MovimenteLimit.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 16/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
public typealias Stopped = (valueX: CGFloat, valueY: CGFloat)
public struct MovimenteLimit {
    var top: CGFloat
    var botton: CGFloat
    var left: CGFloat
    var right: CGFloat
    var stopped: Stopped
    public init (top: CGFloat = 0, botton: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, stopped: Stopped = (0, 0)) {
        self.top = top
        self.botton = botton
        self.left = left
        self.right = right
        self.stopped = stopped
    }

}
