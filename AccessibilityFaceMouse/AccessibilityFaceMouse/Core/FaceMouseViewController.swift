//
//  FaceMouseViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import AVFoundation
import Vision
import UIKit
import Foundation

open class FaceMouseViewController: UIViewController {
    fileprivate let session = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var orientationVideo = CGImagePropertyOrientation.down
    fileprivate var sequenceHandler = VNSequenceRequestHandler()
    fileprivate var getMax: ((CGFloat) -> Void)?
    fileprivate var startCapture: Bool = false
    fileprivate var getXAxis = true

    var medium: CGFloat = 100 {
        didSet {
            GetMaxMoviment.insertMedium(withValue: medium)
        }
    }


    private var count = 0

    let cursor = MousePosition(sensibinity: 20, decimalPlace: 1000, initialPosition: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
    public var imageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 30, height: 30))

    open override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishCapture(_:)), name: .finishCapture, object: nil)
    }

    @objc func finishCapture(_ notification: Notification) {
    }

    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func getView() -> AVCaptureVideoPreviewLayer {
        return previewLayer
    }

    private func getMaxRigth() {
        startCapture = true
        getXAxis = true
        getMax = GetMaxMoviment.calcMaxRight(withValue: )
    }

    private func getMaxLeft() {
        startCapture = true
        getXAxis = true
        getMax = GetMaxMoviment.calcMaxLeft(withValue:)
    }

    private func getMaxTop() {
        startCapture = true
        getXAxis = false
        getMax = GetMaxMoviment.calcMaxTop(withValue:)
    }

    private func getMaxDown() {
        startCapture = true
        getXAxis = false
        getMax = GetMaxMoviment.calcMaxDown(withValue:)
    }

    private func getFaceStopped() {

        startCapture = true
        getXAxis = true
        getMax = GetMaxMoviment.calcStoppedXAxis(withValue: )
    }

    private func getAllPositions() -> Max {
        GetMaxMoviment.getMax()
    }

    public func configureCaptureSession() {
        // Define the capture device we want to use
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
                                                    fatalError("No front video camera available")
        }

        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
        } catch {
            fatalError(error.localizedDescription)
        }

        // Create the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        // Add the video output to the capture session
        session.addOutput(videoOutput)

        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait

        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        session.startRunning()
    }
}
extension FaceMouseViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)

        do {
            try sequenceHandler.perform(
                [detectFaceRequest],
                on: imageBuffer,
                orientation: orientationVideo)
        } catch {
            print(error.localizedDescription)
        }
    }

    func detectedFace(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNFaceObservation] else { return}
        if let landmark = results.first?.landmarks?.nose {
            guard let point = landmark.normalizedPoints.first else { return }
            DispatchQueue.main.async {
                if self.startCapture {
                    if self.getXAxis {
                        self.getMax!(point.x)
                    } else {
                        self.getMax!(point.y)
                    }
                    self.count += 1
                }

                if self.count > 100 {
                    self.count = 0
                    self.startCapture = false
                    NotificationCenter.default.post(name: .finishCapture, object: nil)
                }
            }
        }
    }
}
//let newPosition = self.cursor.moveTo(usingPoint: point)
//UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .transitionCrossDissolve, animations: {
//    self.imageView.center = newPosition
//}, completion: nil)
