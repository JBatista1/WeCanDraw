//
//  FaceTrack.swift
//  FaceTrack
//
//  Created by Joao Batista on 14/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//
import UIKit
import AVFoundation
import Vision

public class AcessibilityFaceTrack {

    let session = AVCaptureSession()
    let customView: UIView

    var sequenceHandler = VNSequenceRequestHandler()
    let math = MathLib()
    let sensibility: CGFloat
    let viewsActions: [Int]
    let timer: Int
    let imageCursor: UIImage
    public init(cutomView: UIView, sensibility: CGFloat, viewsActions: [Int], timer: Int, imageCursor: UIImage = UIImage(named: "cursorDefault")!) {
        self.customView = cutomView
        self.sensibility = sensibility
        self.viewsActions = viewsActions
        self.timer = timer
        self.imageCursor = imageCursor
    }
    public func setupFaceTrack () {
        let screen = UIScreen.main.bounds
        let positionInitial = CGPoint(x: screen.width / 2, y: screen.height / 2)
        let cursor = CursorPosition(sensibinity: 10.0, decimalPlace: 100, initialPosition: positionInitial)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.contentMode = .scaleAspectFill
        imageView.image = imageCursor
//        let _ = FaceCapture(view: customView, cursor: cursor, imageCursor: imageView)
    }

}
