//  Created by warren on 4/25/22.

import Foundation
import Tr3
import MuMenu

enum ExampleTr3Sky {

    static func skyNodes(parent: MuNode? = nil) -> [MuNode] {
        let rootTr3 = SkyTr3.shared.root
        let rootNode = MuNodeTr3(rootTr3)

        if let menuTr3 = rootTr3.findPath("menu") {

            parseTr3(menuTr3, rootNode)
            return rootNode.children.first?.children ?? []

        } else {

            for child in rootTr3.children {
                parseTr3(child, rootNode)
            }
            return rootNode.children
        }

    }

    /// recursively parse tr3 hierachy
    static func parseTr3(_ tr3: Tr3,
                         _ parent: MuNode) {

        let node = MuNodeTr3(tr3, parent: parent)
        for child in tr3.children {
            if child.name.first != "_" {
                parseTr3(child, node)
            }
        }
    }


}


