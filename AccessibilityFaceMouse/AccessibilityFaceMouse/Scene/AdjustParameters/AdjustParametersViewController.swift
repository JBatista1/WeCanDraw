//
//  AdjustParametersTableViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

open class AdjustParametersViewController: FaceMouseViewController {
    let customView = AdjustParameters()

    open override func viewDidLoad() {
        super.viewDidLoad()
        print(UIImage(named: "cursorDefaultHand"))
        imageView.image = UIImage(named: "cursorDefaultHand")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        configureCaptureSession()
    }
    open override func loadView() {

        view = customView
        
    }
}
