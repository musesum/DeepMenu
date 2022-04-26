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


//        func makeTr3Node(_ tr3: Tr3, spotPrev: MuNode?) -> MuNode {
//            return MuNode(.node,)
//        }
//        func parseTr3Nodes(_ tr3: Tr3, spotPrev: MuNode) {
//            let node = makeTr3Node(tr3, spotPrev: spotPrev)
//            spotPrev.childNodes.append(node)
//
//            for child in tr3.children {
//
//            }
//
//        }

        let skyTr3 = SkyTr3.shared
        let root = skyTr3.root

        return []
    }

}


