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
    
    init(limitMoviment: MovimenteLimit) {
        super.init(nibName: nil, bundle: nil)
        self.limitMoviment = limitMoviment
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        limitMoviment.top  = 0.297
//        limitMoviment.botton = 0.588
//        limitMoviment.left = 0.0194
//        limitMoviment.right = 0.794
//        limitMoviment.stopped = (0.00148, 0.00129)
        startMoviment(wihtLimitedMoviment: limitMoviment, andDecimalPlaces: 100)
        
    }
    override func loadView() {
        view = customView
        imageHand.image = Asset.cursorDefaultHand.image
        customView.addSubview(imageHand)
    }

}
