//
//  AdjustParametersTableViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import Combine
open class AdjustParametersViewController: FaceMouseViewController {
    let customView = AdjustParameters()
    private var isFinishDetect: AnyCancellable?
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

    override func finishCapture(_ notification: Notification) {
        print("Fui chamado")
    }
}
extension AdjustParametersViewController: AdjustParametersDelegate {
    func initial() {
        medium = 200
        customView.actionLbl.text = "Mova a cara para a esquerda"
    }

    func final() {

    }
}
