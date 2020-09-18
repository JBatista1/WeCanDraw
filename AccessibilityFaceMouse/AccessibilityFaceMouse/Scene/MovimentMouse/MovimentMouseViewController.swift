//
//  MovimentMouseViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class MovimentMouseViewController: FaceMouseViewController {
    private let customView = MovimentMouse()
    override func viewDidLoad() {
        super.viewDidLoad()
        limitMoviment.top  = 0.159
        limitMoviment.botton = 0.472
        limitMoviment.left = 0.052
        limitMoviment.right = 0.851
        limitMoviment.stopped = (0.0072, 0.0042)
        startMoviment(wihtLimitedMoviment: limitMoviment, andDecimalPlaces: 1000)

        // Do any additional setup after loading the view.
    }
    override func loadView() {
        view = customView
        imageHand.image = Asset.cursorDefaultHand.image
        customView.addSubview(imageHand)
    }

}
