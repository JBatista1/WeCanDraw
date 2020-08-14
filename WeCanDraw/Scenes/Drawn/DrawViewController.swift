//
//  DrawViewController.swift
//  WeCanDraw
//
//  Created by Joao Batista on 03/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import FaceTrack
import AVFoundation

class DrawViewController: FaceCapture {
    let customView = Draw()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "cursorDefault")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        configureCaptureSession()
    }
    override func loadView() {
        view = customView

    }
    override func viewDidAppear(_ animated: Bool) {
    }
}
