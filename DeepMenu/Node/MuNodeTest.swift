// Created by warren on 10/17/21.

import SwiftUI
import Par // CallAny

/// shared between 1 or more MuNodeVm
class MuNodeTest: MuNode {
    
    init(_ name: String,
         type: MuNodeType = .node,
         parent: MuNode? = nil,
         children: [MuNodeTest]? = nil,
         callback: @escaping CallAny = { _ in return })
    {

        super.init(name: name, type: type, callback: callback)
        
        if let children = children {
            for child in children {
                self.addChild(child)
            }
        }
    }

    func setName(from corner: MuCorner) {
        switch corner {
            case [.lower, .right]: name = "◢"
            case [.lower, .left ]: name = "◣"
            case [.upper, .right]: name = "◥"
            case [.upper, .left ]: name = "◤"

                // reserved for later middling roots
            case [.upper]: name = "▲"
            case [.right]: name = "▶︎"
            case [.lower]: name = "▼"
            case [.left ]: name = "◀︎"
            default:       break
        }
    }

    func addChild(_ child: MuNode) {
        children.append(child)
        child.parent = self
    }
    
}
