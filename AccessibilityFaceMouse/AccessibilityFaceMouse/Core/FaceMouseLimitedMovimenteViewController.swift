//
//  FaceMouseLimitedMovimenteViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 14/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import Foundation
import Combine

open class FaceMouseLimitedMovimenteViewController: UIViewController {

    fileprivate let session = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var orientationVideo = CGImagePropertyOrientation.down
    fileprivate var sequenceHandler = VNSequenceRequestHandler()
    fileprivate var getMax: ((CGFloat) -> Void)?
    fileprivate var startCapture: Bool = false
    fileprivate var getXAxis = true
    private var count = 0
    private var lastValue: CGFloat = 0.0
    fileprivate var maxValue: CGFloat = 0.0
    var labelStartScan = UILabel()
    //Combine
    @Published fileprivate var value: Bool = false
    fileprivate var capturedValue: AnyCancellable?

    var medium: CGFloat = 200 {
        didSet {
            GetMaxMoviment.insertMedium(withValue: medium)
        }
    }

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

    func getMaxLeft(completion: @escaping (_ value: CGFloat) -> Void) {
        startCapture = true
        getValue(getXAxis: true) { value in
            completion(value)
        }

    }
    func getMaxRight(completion: @escaping (_ value: CGFloat) -> Void) {
        startCapture = true
        getValue(getXAxis: true) { value in
            completion(value)
        }
    }

    func getValue(getXAxis: Bool, completion: @escaping (_ value: CGFloat) -> Void) {
        startCaptureFace()
        self.getXAxis = getXAxis
        capturedValue = $value.sink { captured in
            if captured == true {
                self.value = false
                self.stopCaptureFace()
                completion(self.maxValue)
            }
        }

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

    private func configureCaptureSession() {
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
    func startCaptureFace() {
        maxValue = 0
        configureCaptureSession()
    }

    func stopCaptureFace() {
        session.stopRunning()
    }
}
extension FaceMouseLimitedMovimenteViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

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

                if ( abs(self.lastValue - point.x)) > 0.1 {
                    self.maxValue = 0.0
                    self.count = 0
                }

                if self.startCapture {
                    if self.count > Int(self.medium/3) {
                        self.labelStartScan.text = "Escaneando..."
                    }

                    if self.getXAxis {
                        let normalize = MathLibs.normalize(value: point.x, decimalValue: 1000)
                        self.maxValue += normalize
                        self.lastValue = point.x
                    } else {
                        let normalize = MathLibs.normalize(value: point.y, decimalValue: 1000)
                        self.maxValue += normalize
                        self.lastValue = point.y
                    }
                    self.count += 1
                    print(point.x)
                }
                if self.count > Int(self.medium) {
                    self.maxValue /= self.medium
                    self.maxValue = MathLibs.normalize(value: self.maxValue, decimalValue: 1000)
                    self.count = 0
                    self.startCapture = false
                    self.value = true
                }
            }
        }
    }
}
