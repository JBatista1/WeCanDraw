//
//  NibView.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 17/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//
import UIKit

class NibView: UIView {

    override init(frame: CGRect) {

        super.init(frame: frame)

        xibSetup()
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)

        xibSetup()
    }

    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
        stretch(view: view)
    }

    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            preconditionFailure("Couldnt load nib. Xib and UIView file might have different names")
        }

        return view
    }

}
