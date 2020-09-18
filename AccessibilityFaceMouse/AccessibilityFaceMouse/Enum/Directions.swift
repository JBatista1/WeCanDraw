//
//  Directions.swift
//  AccessibilityFaceMouse
//
//  Created by Joao Batista on 16/09/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//
import UIKit

enum Directions: String {
    case top = "Cima"
    case botton = "Baixo"
    case left = "Esquerda"
    case right = "Direita"
    case stopped = "Mantenha a cabeça parada olhando para o centro da tela"

    var image: UIImage {
        switch self {
        case .top:
            return Asset.arrowTop.image
        case .botton:
            return Asset.arrowBotton.image
        case .left:
            return Asset.arrowLeft.image
        case .right:
            return Asset.arrowRight.image
        case .stopped:
            return Asset.smile.image

        }
    }
}
