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
    private var movimentLimited = MovimenteLimit()
    private let arrayLimited: [Directions] = [.top, .botton, .left, .right, .stopped]
    private var directionToGet = 0
    private var isFinishDetect: AnyCancellable?
    private let nextViewController: FaceMouseViewController

    public init(nextViewController: FaceMouseViewController) {
        self.nextViewController = nextViewController
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        nextScream()
        customView.delegate = self
        labelStartScan = customView.topLbl
        navigationController?.isNavigationBarHidden = true
    }
    open override func loadView() {
        view = customView
    }
    func scanThePositinUsing(theDirection direction: Directions) {

        switch direction {

        case .top:
            getMaxTop { value in
                self.movimentLimited.top = value
                self.finishScan()
            }

        case .botton:
            getMaxBotton { value in
                self.movimentLimited.botton = value
                self.finishScan()
            }
        case .left:
            getMaxLeft { value in
                self.movimentLimited.left = value
                self.finishScan()
            }
        case .right:
            getMaxRight { value in
                self.movimentLimited.right = value
                self.finishScan()
            }
        case .stopped:
            getFaceStopped(completion: { (valuX, valueY) in
                self.movimentLimited.stopped = (valuX, valueY)

                self.finishScan()
            })
        }

    }
}
extension AdjustParametersViewController: AdjustParametersDelegate {
    func nextScream() {
        let viewController = MovimentMouseViewController()
        viewController.limitMoviment = movimentLimited
        navigationController?.pushViewController(viewController, animated: true)
    }

    func cancel() {
        stopCaptureFace()
        if directionToGet != 0 {
            directionToGet -= 1
        }
        self.customView.actionLbl.text = "Escaneamento cancelado, clique novamente em iniciar para realiza-lo novamente"
        customView.changeButtonDesign()
    }
    func finishScan() {
        self.directionToGet += 1
        customView.changeButtonDesign()
        if directionToGet == arrayLimited.count {
             self.customView.topLbl.text = "Escaneamento finalizado, clique em iniciar para prosseeguir"
        } else {
            self.customView.topLbl.text = "Clique em iniciar para o próximo scaner. Faltam apenas \(arrayLimited.count - directionToGet)"
        }

    }

    func initial() {
        if directionToGet < arrayLimited.count {
            let direction = arrayLimited[directionToGet]
            customView.ImageCenter.image = direction.image
            self.customView.topLbl.text = direction != Directions.stopped ? "Mova sua cabeça para \(direction.rawValue)": direction.rawValue
            scanThePositinUsing(theDirection: direction)
        } else {
            customView.toggleNext()
        }
    }
}
