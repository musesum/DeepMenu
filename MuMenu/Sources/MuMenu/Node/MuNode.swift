// Created by warren on 5/6/22.

import SwiftUI

open class MuNode: Identifiable, Equatable {
    public let id = MuIdentity.getId()

    public var name: String
    public var children = [MuNode]()
    public var proto: MuNodeProtocol?
    public var proxies = [MuLeafProxy]()

    public static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    public init(name: String,
         parent: MuNode? = nil) {

        self.name = name
        parent?.children.append(self)
    }

    /// overrides this to add controls to the Menu
    open func leafType() -> MuNodeType? {
        return nil
    }


}
