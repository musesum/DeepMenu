//
//  MuNode.swift
//  DeepMenu
//
//  Created by warren on 5/6/22.
//

import Foundation
import Par

class MuNode: Identifiable, Equatable, CustomStringConvertible {

    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging

    var name: String
    var parent: MuNode? = nil
    var children = [MuNode]()
    var childNow: MuNode? // most recently selected nodeModel
    var callback: ((Any) -> Void)
    var nodeType: MuNodeType

    var description : String {
        return "\(type(of:self)): \"\(name)\" .\(nodeType)"
    }

    static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    init(name: String = "pending",
         type: MuNodeType = .node,
         callback: @escaping CallAny) {
        self.name = name
        self.nodeType = type
        self.callback = callback
    }
}
