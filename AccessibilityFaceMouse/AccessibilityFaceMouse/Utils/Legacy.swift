
//
//import Foundation
//import AVFoundation
//import Vision
//import UIKit
//import Foundation
//
//open class FaceMouseViewController: UIViewController {
//    fileprivate let session = AVCaptureSession()
//    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
//    fileprivate var orientationVideo = CGImagePropertyOrientation.down
//    fileprivate var sequenceHandler = VNSequenceRequestHandler()
//    open var limitMoviment = MovimenteLimit()
//    let cursor = MousePosition(sensibinity: 20, decimalPlace: 1000, initialPosition: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
//
//    public var imageHand = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 30, height: 30))
//    let dataOutputQueue = DispatchQueue(
//        label: "video data queue",
//        qos: .userInitiated,
//        attributes: [],
//        autoreleaseFrequency: .workItem)
//
//    func getView() -> AVCaptureVideoPreviewLayer {
//        return previewLayer
//    }
//
//    public func configureCaptureSession() {
//        // Define the capture device we want to use
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                   for: .video,
//                                                   position: .front) else {
//                                                    fatalError("No front video camera available")
//        }
//
//        // Connect the camera to the capture session input
//        do {
//            let cameraInput = try AVCaptureDeviceInput(device: camera)
//            session.addInput(cameraInput)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//
//        // Create the video data output
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
//        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//
//        // Add the video output to the capture session
//        session.addOutput(videoOutput)
//
//        let videoConnection = videoOutput.connection(with: .video)
//        videoConnection?.videoOrientation = .portrait
//
//        // Configure the preview layer
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.bounds
//        view.layer.insertSublayer(previewLayer, at: 0)
//        session.startRunning()
//    }
//}
//extension FaceMouseViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
//
//        do {
//            try sequenceHandler.perform(
//                [detectFaceRequest],
//                on: imageBuffer,
//                orientation: orientationVideo)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func detectedFace(request: VNRequest, error: Error?) {
//        guard let results = request.results as? [VNFaceObservation] else { return}
//        if let landmark = results.first?.landmarks?.nose {
//            guard let point = landmark.normalizedPoints.first else { return }
//            DispatchQueue.main.async {
//                let newPosition = self.cursor.moveTo(usingPoint: point)
//                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .transitionCrossDissolve, animations: {
//                    self.imageHand.center = newPosition
//                }, completion: nil)
//            }
//        }
//    }
//}
//
//  CursosPosition.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

//import Foundation
//import UIKit
//
//class MousePosition {
//    let sensibility: CGFloat!
//    let decimalPlace: CGFloat!
//    let marginMovimentX: Float = 0.02
//    let marginMovimentY: Float = 0.02
//    var lastPoint: CGPoint!
//    var lastPointFace = CGPoint(x: 0.0, y: 0.0)
//    var count = 0
//    var count2 = 0
//    public var mediaX: [Float] = []
//    var mediaValues: [Float] = []
//
//    init(sensibinity: CGFloat, decimalPlace: CGFloat, initialPosition: CGPoint) {
//        self.sensibility = sensibinity
//        self.decimalPlace = decimalPlace
//        self.lastPoint = initialPosition
//    }
//
//    func moveTo(usingPoint point: CGPoint) -> CGPoint {
//
//        let positionX = MathLibs.normalize(value: point.x, decimalValue: decimalPlace)
//        let positionY = MathLibs.normalize(value: point.y, decimalValue: decimalPlace)
//        var position = CGPoint()
//
//        if positionX >= 0.45 {
//            if positionY >= 0.31 {
//                position = CGPoint(x: lastPoint.x + sensibility, y: lastPoint.y + sensibility )
//            } else {
//                position = CGPoint(x: lastPoint.x + sensibility, y: lastPoint.y - sensibility )
//            }
//        } else {
//            if positionY >= 0.21 {
//                position = CGPoint(x: lastPoint.x - sensibility, y: lastPoint.y + sensibility )
//            } else {
//                position = CGPoint(x: lastPoint.x - sensibility, y: lastPoint.y - sensibility)
//            }
//        }
//
//        if absoluteValue(cgFloat: (point.x - lastPointFace.x )) < marginMovimentX {
//            position.x = lastPoint.x
//        }
//        if absoluteValue(cgFloat: (point.y - lastPointFace.y )) < marginMovimentY {
//            position.y = lastPoint.y
//        }
//
//        position = verifyLimits(position: position)
//        lastPoint = position
//        lastPointFace = point
//
//        return position
//    }
//
//    private func absoluteValue(cgFloat value: CGFloat) -> Float {
//        var valueFloat = Float(value)
//        valueFloat = fabsf(valueFloat)
//        //        mediaFacePosition(value: valueFloat)
//        return valueFloat
//    }
//    //Calcula media parado
//    func mediaFacePosition(value: Float) {
//        count += 1
//        mediaX.append(value)
//        if count >= 50 {
//            let media = mediaX.reduce(0, +)
//            mediaValues.append(media/Float(count))
//            count = 0
//            mediaX = []
//            count2 += 1
//        }
//        if count2 > 10 {
//            print("VALOR DA MEDIA PARADO Y")
//            for i in mediaValues {
//                print(i)
//            }
//            exit(0)
//        }
//    }
//    func verifyLimits(position: CGPoint) -> CGPoint {
//        var positionNew = position
//        let height = UIScreen.main.bounds.height
//        let width = UIScreen.main.bounds.width
//        if position.x > width || position.x < 0 {
//            positionNew.x = lastPoint.x
//        }
//        if position.y > height || position.y < 0 {
//            positionNew.y = lastPoint.y
//        }
//        return positionNew
//    }
//}
