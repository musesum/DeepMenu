// Created by warren on 10/17/21.

import SwiftUI

/// shared between 1 or more MuNode, stored
class MuNodeModel: Identifiable, Equatable, CustomStringConvertible {
    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging
    
    var name: String // pilot's name may be changed rootd on corner placement
    let nodeType: MuNodeType
    var children = [MuNodeModel]()
    var subNow:  MuNodeModel? // most recently selected, persist to storage
    var callback: ((Any) -> Void)

    var parent: MuNodeModel? = nil

    var description : String {
        return "\(type(of:self)): \"\(name)\" .\(nodeType)"
    }

    static func == (lhs: MuNodeModel, rhs: MuNodeModel) -> Bool {
        return lhs.id == rhs.id
    }

    init(_ name: String,
         type: MuNodeType = .node,
         parentModel: MuNodeModel? = nil,
         children: [MuNodeModel]? = nil,
         callback: @escaping (Any) -> Void = { _ in return })
    {

        self.name = name
        self.nodeType = type
        self.callback = callback
        
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

    func addChild(_ child: MuNodeModel) {
        children.append(child)
        child.parent = self
    }
    
}
