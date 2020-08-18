//
//  CursosPosition.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import Foundation
import UIKit

class MousePosition {
    let math = MathLibs()
    let sensibility: CGFloat!
    let decimalPlace: CGFloat!
    let marginMovimentX: Float = 0.02
    let marginMovimentY: Float = 0.02
    var lastPoint: CGPoint!
    var lastPointFace = CGPoint(x: 0.0, y: 0.0)
    var count = 0
    var count2 = 0
    public var mediaX: [Float] = []
    var mediaValues: [Float] = []

    init(sensibinity: CGFloat, decimalPlace: CGFloat, initialPosition: CGPoint) {
        self.sensibility = sensibinity
        self.decimalPlace = decimalPlace
        self.lastPoint = initialPosition
    }

    func moveTo(usingPoint point: CGPoint) -> CGPoint {

        let positionX = math.normalize(value: point.x, decimalValue: decimalPlace)
        let positionY = math.normalize(value: point.y, decimalValue: decimalPlace)
        var position = CGPoint()

        if positionX >= 0.45 {
            if positionY >= 0.31 {
                position = CGPoint(x: lastPoint.x + sensibility, y: lastPoint.y + sensibility )
            } else {
                position = CGPoint(x: lastPoint.x + sensibility, y: lastPoint.y - sensibility )
            }
        } else {
            if positionY >= 0.21 {
                position = CGPoint(x: lastPoint.x - sensibility, y: lastPoint.y + sensibility )
            } else {
                position = CGPoint(x: lastPoint.x - sensibility, y: lastPoint.y - sensibility)
            }
        }

        if absoluteValue(cgFloat: (point.x - lastPointFace.x )) < marginMovimentX {
            position.x = lastPoint.x
        }
        if absoluteValue(cgFloat: (point.y - lastPointFace.y )) < marginMovimentY {
            position.y = lastPoint.y
        }

        position = verifyLimits(position: position)
        lastPoint = position
        lastPointFace = point

        return position
    }

    private func absoluteValue(cgFloat value: CGFloat) -> Float {
        var valueFloat = Float(value)
        valueFloat = fabsf(valueFloat)
        //        mediaFacePosition(value: valueFloat)
        return valueFloat
    }
    //Calcula media parado
    func mediaFacePosition(value: Float) {
        count += 1
        mediaX.append(value)
        if count >= 50 {
            let media = mediaX.reduce(0, +)
            mediaValues.append(media/Float(count))
            count = 0
            mediaX = []
            count2 += 1
        }
        if count2 > 10 {
            print("VALOR DA MEDIA PARADO Y")
            for i in mediaValues {
                print(i)
            }
            exit(0)
        }
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
