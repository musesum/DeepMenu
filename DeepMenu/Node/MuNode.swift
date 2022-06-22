// Created by warren on 5/6/22.

import SwiftUI

class MuNode: Identifiable, Equatable {
    let id = MuIdentity.getId()

    var name: String
    var children = [MuNode]()
    var proto: MuNodeProtocol?
    var leaves = [MuLeafModelProtocol]()

    static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    init(name: String,
         parent: MuNode? = nil) {

        self.name = name
        parent?.children.append(self)
    }

    /// overrides this to add controls to the Menu
    func leafType() -> MuNodeType? {
        return nil
    }


}
