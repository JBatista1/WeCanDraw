//
//  AdjustParameters.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class AdjustParameters: NibView {

    @IBOutlet weak var ImageCenter: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    private var changeColor =  true
    override init(frame: CGRect) {
        super.init(frame: frame)
        actionButton.setShadowAndCornerRadius(withColor: .black, Offset: CGSize(width: 0, height: 0), Opacity: 0.4, Radius: 3, andCornerRadius: actionButton.frame.height/2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func tapButton(_ sender: Any) {
        if changeColor {
            actionButton.backgroundColor = UIColor.pinkApp
            actionButton.setTitle("Cancelar", for: .normal)
            changeColor = !changeColor
        } else {
            actionButton.backgroundColor = UIColor.greenApp
            actionButton.setTitle("Iniciar", for: .normal)
            changeColor = !changeColor
        }

    }
}
