//
//  NewMousePosition.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class MousePosition {
    private let decimalPlace: CGFloat
    private let limitedMoviment: MovimenteLimit
    private let heightScream = UIScreen.main.bounds.height
    private let widthScream = UIScreen.main.bounds.width

    init(decimalPlace: CGFloat, limitedMoviment: MovimenteLimit ) {
        self.decimalPlace = decimalPlace
        self.limitedMoviment = limitedMoviment
    }
    func moveTo(usingPoint point: CGPoint) -> CGPoint {
        var newPoint = CGPoint(x: 0, y: 0)
        let heightScreemMoviment = limitedMoviment.botton - limitedMoviment.top
        let widthScreemMoviment = limitedMoviment.right - limitedMoviment.left
        let heightRatio =  heightScream / heightScreemMoviment
        let widthRatio = widthScream / widthScreemMoviment
        newPoint.x = MathLibs.normalize(value: (point.x * widthRatio), decimalValue: decimalPlace)
        newPoint.y = MathLibs.normalize(value: (point.y * heightRatio), decimalValue: decimalPlace)
        if itsOntheScreen(position: newPoint) {
            return newPoint
        } else {
            return point
        }
    }
    func itsOntheScreen(position: CGPoint) -> Bool {
        if position.x > widthScream || position.x < 0 {
            return false
        }
        if position.y > heightScream || position.y < 0 {
            return false
        }
        return true
    }
}
