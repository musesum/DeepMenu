//
//  MuNodeTr3.swift
//  DeepMenu
//
//  Created by warren on 5/5/22.
//
// Created by warren on 10/17/21.

import SwiftUI
import Tr3
import Par


/// shared between 1 or more MuNodeVm
class MuNodeTr3: MuNode {

    var tr3: Tr3

    init(_ tr3: Tr3,
         type: MuNodeType = .node,
         parent: MuNode? = nil,
         callback: @escaping CallAny = { _ in return })
    {
        self.tr3 = tr3
        super.init(type: type, parent: parent, callback: callback)
        self.name = tr3.name
    }
}