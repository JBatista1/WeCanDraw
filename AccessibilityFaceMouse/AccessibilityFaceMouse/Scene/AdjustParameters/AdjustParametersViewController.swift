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
        imageView.image = UIImage(named: "cursorDefaultHand")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        configureCaptureSession()
        customView.delegate = self

    }
    open override func loadView() {
        view = customView
    }
}
extension AdjustParametersViewController: AdjustParametersDelegate {
    func initial() {
        getMax = GetMaxMoviment.calcMaxRight(withValue: )
        customView.actionLbl.text = "Mova a cara para a esquerda"
        startCapture = true
    }

    func final() {

    }
}
