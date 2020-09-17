//
//  AdjustParametersTableViewController.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import Combine
open class AdjustParametersViewController: FaceMouseLimitedMovimenteViewController {
    let customView = AdjustParameters()
    private var isFinishDetect: AnyCancellable?
    open override func viewDidLoad() {
        super.viewDidLoad()
        customView.delegate = self
        labelStartScan = customView.actionLbl
       
    }

    open override func loadView() {
        view = customView
    }

}
extension AdjustParametersViewController: AdjustParametersDelegate {
    func final() {
        stopCaptureFace()
    }

    func initial() {
        self.customView.actionLbl.text = "Mova sua cabeça para a a direita"
        getFaceStopped { (valueX, valueY) in
            print(valueX)
            print(valueY)
        }
//        getMaxLeft { value in
//            self.customView.actionLbl.text = "Capturado and \(value)"
//            self.customView.changeButtonDesign()
        }
    }
