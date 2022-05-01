//
//  ExampleTr3Sky.swift
//  DeepMenu
//
//  Created by warren on 4/25/22.
//

import Foundation
import Tr3


enum ExampleTr3Sky {

    static func skyNodes(parentModel: MuNodeModel? = nil, _ level: Int = 0) -> [MuNodeModel] {

        func parseTr3(_ tr3: Tr3, parentModel: MuNodeModel) {

            var icon = ""
            var leafType = MuNodeType.none

            if let exprs = tr3.val as? Tr3Exprs {

                for expr in exprs.exprs {
                    let type = MuNodeType(expr.name)
                    if type != .none {
                        leafType = type
                    } else {
                        switch expr.name {
                            case "icon": icon = expr.string
                            default: break
                        }
                    }
                }
            }
            let nodeModel = MuNodeModel(tr3.name, type: .node, parentModel: parentModel)
            parentModel.children.append(nodeModel)

            if leafType == .none {
                for tr3Child in tr3.children {
                    if tr3Child.name.first != "_" {
                        parseTr3(tr3Child, parentModel: nodeModel)
                    }
                }
            } else {
                let leafModel = MuNodeModel(tr3.name, type: leafType, parentModel: nodeModel)
                nodeModel.children.append(leafModel)
            }
        }

        let root = SkyTr3.shared.root
        let rootModel = MuNodeModel("root")

        for child in root.children {
            parseTr3(child, parentModel: rootModel)
        }

        return rootModel.children
    }

}


