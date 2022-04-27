//
//  ExampleTr3Sky.swift
//  DeepMenu
//
//  Created by warren on 4/25/22.
//

import Foundation
import Tr3


enum ExampleTr3Sky {

    static func skyNodes(parentModel: MuNodeModel? = nil,
                         _ level: Int = 0) -> [MuNodeModel] {

        func parseTr3(_ tr3: Tr3, parentModel: MuNodeModel) {

            let childModel = MuNodeModel(tr3.name, type: .node, parentModel: parentModel)
            parentModel.children.append(childModel)
            for child in tr3.children {
                parseTr3(child, parentModel: childModel)
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


