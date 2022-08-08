//  Created by warren on 4/25/22.

import Foundation
import Tr3
import MuMenu

enum ExampleTr3Sky {

    static func skyNodes(parent: MuNode? = nil) -> [MuNode] {
        let rootTr3 = SkyTr3.shared.root
        let rootNode = MuNodeTr3(rootTr3)

        if let menuTr3 = rootTr3.findPath("menu") {

            if let modelTr3 = menuTr3.findPath("model"),
               let viewTr3  = menuTr3.findPath("view") {

                let node = parseTr3(modelTr3, rootNode)
                mergeTr3(viewTr3, node)

            } else {

                _ = parseTr3(menuTr3, rootNode)

            }
            return rootNode.children.first?.children ?? []

        } else {

            for child in rootTr3.children {
                _ = parseTr3(child, rootNode)
            }
            return rootNode.children
        }
    }

    /// recursively parse tr3 hierachy
    static func parseTr3(_ tr3: Tr3,
                         _ parentNode: MuNode) -> MuNodeTr3 {

        let node = MuNodeTr3(tr3, parent: parentNode)
        for child in tr3.children {
            if child.name.first != "_" {
                _ = parseTr3(child, node)
            }
        }
        return node
    }

    /// merge menu.view with with menu.model
    static func mergeTr3(_ viewTr3: Tr3,
                         _ parentNode: MuNode) {

        func findTr3Node(_ tr3: Tr3) -> MuNode? {
            if parentNode.title == tr3.name {
                return parentNode
            }
            for childNode in parentNode.children {
                if childNode.title == tr3.name {
                    return childNode
                }
            }
            return nil
        }

        for child in viewTr3.children {
            if let nodeTr3 = findTr3Node(child) as? MuNodeTr3 {
                nodeTr3.icon = MuNodeTr3.makeTr3Icon(child)
                mergeTr3(child, nodeTr3)
            }
        }

    }

}


