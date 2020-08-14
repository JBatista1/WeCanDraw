//
//  AvcaptureProtocol.swift
//  WeCanDraw
//
//  Created by Joao Batista on 14/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AcessibilityViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let videoQueue = DispatchQueue(label: "VIDEO_QUEUE")

    func setupVideo() {
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        captureSession.addInput(input)

        captureSession.startRunning()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        captureSession.addOutput(dataOutput)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Camera was able to capture a frame:", Date())
    }
}
