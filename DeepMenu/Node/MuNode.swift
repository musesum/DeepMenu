// Created by warren on 5/6/22.

import UIKit
import Par

public typealias CallAnyVisitor = ((Any,Visitor)->())

class MuNode: Identifiable, Equatable {

    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging

    var name: String
    var children = [MuNode]()
    var value: MuNodeValue?
    var leaf: MuLeaf?

    static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    init(name: String,
         parent: MuNode? = nil) {

        self.name = name
        parent?.children.append(self)
    }


}
