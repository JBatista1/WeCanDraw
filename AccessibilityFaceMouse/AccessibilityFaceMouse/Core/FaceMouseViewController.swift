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
    open var limitMoviment = MovimenteLimit()
    var cursor: MousePosition!
    private var count = 0
    public var imageHand = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 30, height: 30))
    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func getView() -> AVCaptureVideoPreviewLayer {
        return previewLayer
    }
    
    public func startMoviment(wihtLimitedMoviment: MovimenteLimit, andDecimalPlaces decimalPlace: CGFloat) {
        cursor = MousePosition(sensibinity: 5, decimalPlace: 100, initialPosition: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2), limitMoviment: limitMoviment)
        configureCaptureSession()
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
        camera.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 30)
        camera.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 30)

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
            let newPosition = self.cursor.moveTo(usingPoint: point)
            print(point)
            DispatchQueue.main.async {
                if self.count == 5 {
                    UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .transitionCrossDissolve, animations: {
                        self.imageHand.center = newPosition
                        self.count = 0
                    }, completion: nil)

                } else {
                    self.count += 1
                }
            }
        }
    }
}
