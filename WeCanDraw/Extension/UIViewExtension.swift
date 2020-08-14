//
//  UIViewExtension.swift
//  Sonar
//
//  Created by Joao Batista on 24/07/20.
//  Copyright © 2020 ioasys. All rights reserved.
//

import UIKit
extension UIView {
    
    func stretch(view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: topAnchor, constant: top),
                                     view.leftAnchor.constraint(equalTo: leftAnchor, constant: left),
                                     view.rightAnchor.constraint(equalTo: rightAnchor, constant: right),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom)])
    }
    
    func makeRoundBorder(withCornerRadius corneRadius: CGFloat) {
        layer.cornerRadius = corneRadius
        layer.masksToBounds = true
    }
    
    func insertBorder(withWidth width: CGFloat, andColor color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
