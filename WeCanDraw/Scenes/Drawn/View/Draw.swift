//
//  Draw.swift
//  WeCanDraw
//
//  Created by Joao Batista on 14/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class Draw: NibView {

    var tagsImages: [Int] = []
    @IBOutlet weak var feedBack: UILabel!
    @IBOutlet weak var clickedBlue: UIButton!
    @IBOutlet weak var clickedPurple: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        clickedBlue.tag = 1
        clickedPurple.tag = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
