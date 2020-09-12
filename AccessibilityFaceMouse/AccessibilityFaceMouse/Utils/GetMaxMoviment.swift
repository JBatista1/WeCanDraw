//
//  GetMaxMoviment.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 11/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
typealias Max = (maxTop: CGFloat, maxDown: CGFloat, maxLeft: CGFloat, maxRight: CGFloat, faceStopped: CGFloat)
class GetMaxMoviment {

    private static var maxTop: CGFloat = 0.0
    private static var maxDown: CGFloat = 0.0
    private static var maxLeft: CGFloat = 0.0
    private static var maxRight: CGFloat = 0.0
    private static var medium: CGFloat = 0.0
    private static var faceStoppedXAxis: CGFloat = 0.0
    private static var faceStoppedYAxis: CGFloat = 0.0

    static func getMax() -> Max {
        return(maxTop/medium, maxDown/medium, maxLeft/medium, maxRight/medium, faceStoppedXAxis/medium)
    }
    static func calcMaxTop(withValue value: CGFloat) {
        maxTop += value
    }
    static func calcMaxDown(withValue value: CGFloat) {
        maxDown += value
    }
    static func calcMaxLeft(withValue value: CGFloat) {
        maxLeft += value
    }
    static func calcMaxRight(withValue value: CGFloat) {
        maxRight += value
    }
    static func insertMedium(withValue value: CGFloat) {
        medium = value
    }
    static func calcStoppedXAxis(withValue value: CGFloat) {
        faceStoppedXAxis += value
    }
    static func calcStoppedYAxis(withValue value: CGFloat) {
        faceStoppedYAxis += value
    }
}
