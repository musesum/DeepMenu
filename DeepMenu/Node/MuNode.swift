//
//  MuNode.swift
//  DeepMenu
//
//  Created by warren on 5/6/22.
//

import Foundation
import Par


class MuNode: Identifiable, Equatable {

    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging

    var name: String
    var children = [MuNode]()
    var childNow: MuNode? // most recently selected nodeModel
    var callback: ((Any) -> Void)

    static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    init(name: String,
         parent: MuNode? = nil,
         callback: @escaping CallAny) {

        self.name = name
        self.callback = callback
        parent?.children.append(self)
    }
}
