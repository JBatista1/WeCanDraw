//
//  FaceCapture.swift
//  FaceTrack
//
//  Created by Joao Batista on 14/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import Foundation
import AVFoundation
import Vision
import UIKit

open class FaceCapture: UIViewController {
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var orientationVideo = CGImagePropertyOrientation.down
    var sequenceHandler = VNSequenceRequestHandler()
    let cursor = CursorPosition(sensibinity: 20, decimalPlace: 1000, initialPosition: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
    public var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func getView() -> AVCaptureVideoPreviewLayer {
        return previewLayer
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
extension FaceCapture: AVCaptureVideoDataOutputSampleBufferDelegate {

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
                let newPosition = self.cursor.moveTo(usingPoint: point)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .transitionCrossDissolve, animations: {
                    self.imageView.center = newPosition
                }, completion: nil)
            }
        }
    }
}
