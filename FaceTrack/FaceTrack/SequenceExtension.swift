//
//  SequenceExtension.swift
//  FaceTrack
//
//  Created by Joao Batista on 14/08/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
