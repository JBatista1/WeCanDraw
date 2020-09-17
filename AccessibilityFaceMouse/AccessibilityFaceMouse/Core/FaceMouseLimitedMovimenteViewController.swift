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
private typealias Center = (valueX: CGFloat, valueY: CGFloat)

open class FaceMouseLimitedMovimenteViewController: UIViewController {

    fileprivate let session = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var orientationVideo = CGImagePropertyOrientation.down
    fileprivate var sequenceHandler = VNSequenceRequestHandler()
    fileprivate var getMax: ((CGFloat) -> Void)?
    fileprivate var startCapture: Bool = false
    fileprivate var getXAxis = true
    fileprivate var center: Center = (0, 0)
    fileprivate var isCaptureCenter: Bool = false
    private var count = 0
    private var lastValue: CGFloat = 0.0
    private var lastValueY: CGFloat = 0.0
    fileprivate var maxValue: CGFloat = 0.0
    var labelStartScan = UILabel()

    //Combine
    @Published fileprivate var value: Bool = false
    fileprivate var capturedValue: AnyCancellable?

    var medium: CGFloat = 200 

    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func startCaptureFace() {
        maxValue = 0
        configureCaptureSession()
    }

    func stopCaptureFace() {
        session.stopRunning()
    }
}

// MARK: - Get Limited moviment
extension FaceMouseLimitedMovimenteViewController {

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
    func getMaxTop(completion: @escaping (_ value: CGFloat) -> Void) {
        startCapture = true
        getValue(getXAxis: false) { value in
            completion(value)
        }
    }

    func getMaxBotton(completion: @escaping (_ value: CGFloat) -> Void) {
        startCapture = true
        getValue(getXAxis: false) { value in
            completion(value)
        }
    }
    func getFaceStopped(completion: @escaping (_ valueX: CGFloat, _ valueY: CGFloat) -> Void) {
        startCaptureFace()
        startCapture = true
        isCaptureCenter = true
        capturedValue = $value.sink { captured in
            if captured == true {
                self.value = false
                self.isCaptureCenter = false
                self.stopCaptureFace()
                completion(self.center.valueX, self.center.valueY)
            }
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
}

extension FaceMouseLimitedMovimenteViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
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

                //Update View To startScan
                if self.count > Int(self.medium/4) {
                    self.labelStartScan.text = "Escaneando..."
                }
                if self.isCaptureCenter {
                    if !self.valideCaptureCenter(usingValueX: point.x, andValueY: point.y) {
                        self.resetCounter()
                    }
                    self.captureCenter(withPoint: point)
                    print(point)
                } else {
                    if !self.validCapture(usingValue: self.getPointToCalculed(inPoint: point), andLastValue: self.lastValue) {
                        self.resetCounter()
                    }
                    self.captureMax(withValue: self.getPointToCalculed(inPoint: point))
                }
                self.count += 1
            }
        }
    }

    private func sum(valueWith value: CGFloat, inValue valueMax: inout CGFloat) {
        let normalize = MathLibs.normalize(value: value, decimalValue: 1000)
        valueMax += normalize
    }
    private func subtration(valueWith value: CGFloat, ofLastValue lastValue: inout CGFloat) -> CGFloat {
        if lastValue != 0 {
            let normalize = MathLibs.normalize(value: value, decimalValue: 10000)
            let difference = abs(lastValue - normalize)
            return difference
        }
        return 0.0
    }
    private func captureCenter(withPoint point: CGPoint) {
        center.valueX += subtration(valueWith: point.x, ofLastValue: &lastValue)
        center.valueY += subtration(valueWith: point.y, ofLastValue: &lastValueY)
        lastValue = point.x
        lastValueY = point.y
        if isFinishCapture() {
            // -1 due first calculation that returns zero
            self.center.valueX /= (medium - 1)
            self.center.valueY /= (medium - 1)
            isCaptureCenter = false
            resetCapture()
        }
    }
    private func captureMax(withValue value: CGFloat) {
        self.sum(valueWith: value, inValue: &self.maxValue)
        if isFinishCapture() {
            self.maxValue /= self.medium
            self.maxValue = MathLibs.normalize(value: self.maxValue, decimalValue: 1000)
        }
    }
    private func isFinishCapture() -> Bool {
        return (self.count > Int(self.medium))
    }
    private func validCapture(usingValue valuePoint: CGFloat, andLastValue lastValue: CGFloat) -> Bool {
        return ((abs(lastValue - valuePoint)) < 0.1)
    }
    private func valideCaptureCenter(usingValueX valuePointX: CGFloat, andValueY valuePointY: CGFloat) -> Bool {
        return validCapture(usingValue: valuePointX, andLastValue: self.lastValue) && validCapture(usingValue: valuePointY, andLastValue: self.lastValueY)
    }
    private func resetCounter() {
        self.maxValue = 0.0
        self.count = 0
    }
    private func getPointToCalculed(inPoint point: CGPoint) -> CGFloat {
        if getXAxis {
            return point.x
        } else {
            return point.y
        }
    }
    private func resetCapture() {
        self.count = 0
        self.startCapture = false
        self.value = true
    }
}
