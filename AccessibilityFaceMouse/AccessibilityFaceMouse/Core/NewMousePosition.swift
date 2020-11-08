//
//  NewMousePosition.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class MousePosition {
    let sensibility: CGFloat!
    let decimalPlace: CGFloat!
    let marginMovimentX: Float = 0.02
    let marginMovimentY: Float = 0.02
    var lastPoint: CGPoint!
    var lastPointFace = CGPoint(x: 0.0, y: 0.0)
    var moveToRight = false
    var moveToTop = false
    public var mediaX: [Float] = []
    var mediaValues: [Float] = []
    var limitedMoviment: MovimenteLimit
    private let heightScreen = UIScreen.main.bounds.height
    private let widthScreen = UIScreen.main.bounds.width
    var faceMoviment : (width: CGFloat, height: CGFloat) = (0, 0)
    init(sensibinity: CGFloat, decimalPlace: CGFloat, initialPosition: CGPoint, limitMoviment: MovimenteLimit) {
        self.sensibility = sensibinity
        self.decimalPlace = decimalPlace
        self.lastPoint = initialPosition
        self.limitedMoviment = limitMoviment
        faceMoviment = getSizeFaceMoviment()
        lastPoint.y = heightScreen
    }

    func moveTo(usingPoint point: CGPoint) -> CGPoint {
        var newPoint = CGPoint(x: 300, y: 0)
        if point.y > limitedMoviment.botton {
            newPoint.y = heightScreen
        } else if point.y < limitedMoviment.top {
            newPoint.y = 0
        } else {
             newPoint.y = getAbsolutePositiion(basedPositionFace: point.y, theFaceMaxValue: faceMoviment.height, andScreenMaxValue: heightScreen)
        }
        newPoint.x = getAbsolutePositiion(basedPositionFace: point.x, theFaceMaxValue: faceMoviment.width, andScreenMaxValue: widthScreen)
        if abs(lastPoint.y - newPoint.y) < limitedMoviment.stopped.valueY {
            return lastPoint
        }
        lastPoint = newPoint
        return newPoint
    }

    private func absoluteValue(cgFloat value: CGFloat) -> Float {
        var valueFloat = Float(value)
        valueFloat = fabsf(valueFloat)
        return valueFloat
    }

    private func newPointAxis() -> CGFloat {
        if moveToRight {
            return lastPoint.x + sensibility
        } else {
            return lastPoint.x - sensibility
        }
    }
    func verify(thatPosition position: CGFloat, IslargerThanScreen scremValue: CGFloat) -> Bool {
        return position > scremValue
    }
    func getAbsolutePositiion(basedPositionFace position: CGFloat, theFaceMaxValue faceValueMax: CGFloat, andScreenMaxValue screenMaxValue: CGFloat) -> CGFloat {
        let percentage = getPercentage(withValue: position, andMaxValue: faceValueMax)
        let absolutePosition = getValue(withPercentage: percentage, andMaxValue: screenMaxValue)
        return absolutePosition
    }
//    func getPercentage(withValue value: CGFloat, andMaxValue maxValue: CGFloat) -> CGFloat {
//        let percentage = (value.multiply100()) / maxValue
//        if  percentage > 100 {
//            return 100
//        } else if percentage/maxValue < 0 {
//            return 0
//        } else {
//            return percentage
//        }
//    }
    func getPercentage(withValue value: CGFloat, andMaxValue maxValue: CGFloat) -> CGFloat {
        let valueScaled = ((value.multiply100() - faceMoviment.height.multiply100()) / 100)
        let percentage = (valueScaled.multiply100()) / maxValue
        if  percentage > 100 {
            return 100
        } else if percentage/maxValue < 0 {
            return 0
        } else {
            return percentage
        }
    }


    func getValue(withPercentage percentage: CGFloat, andMaxValue maxValue: CGFloat) -> CGFloat {
        return (maxValue * percentage)/100
    }

    func getSizeFaceMoviment() -> (width: CGFloat, height: CGFloat) {
        return(abs(limitedMoviment.right.multiply100() - limitedMoviment.left.multiply100()) / 100, abs(limitedMoviment.botton.multiply100() - limitedMoviment.top.multiply100()) / 100)
    }

    func verifyLimits(position: CGPoint) -> CGPoint {
        var positionNew = position
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        if position.x > width || position.x < 0 {
            positionNew.x = lastPoint.x
        }
        if position.y > height || position.y < 0 {
            positionNew.y = lastPoint.y
        }
        return positionNew
    }
}
