// Created by warren on 10/17/21.

import SwiftUI

/// shared between 1 or more MuPod, stored
class MuPodModel: Identifiable, Equatable, CustomStringConvertible {
    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging
    
    var name: String // pilot's name may be changed hubd on corner placement
    let title: String
    let borderType: MuBorderType
    var subModels = [MuPodModel]()
    var subNow:  MuPodModel? // most recently selected, persist to storage
    var callback: ((Any) -> Void)

    var parent: MuPodModel? = nil

    var description : String {
        return "\(type(of:self)): \"\(name)\" .\(borderType)"
    }

    static func == (lhs: MuPodModel, rhs: MuPodModel) -> Bool {
        return lhs.id == rhs.id
    }

    init(_ name: String,
         type: MuBorderType = .pod,
         suprModel: MuPodModel? = nil,
         subModels: [MuPodModel]? = nil,
         callback: @escaping (Any) -> Void = { _ in return })
    {

        self.name = name
        self.borderType = type
        self.title = (suprModel?.title ?? "") + name
        self.callback = callback
        
        if let children = subModels {
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

                // reserved for later middling hubs
            case [.upper]: name = "▲"
            case [.right]: name = "▶︎"
            case [.lower]: name = "▼"
            case [.left ]: name = "◀︎"
            default:       break
        }
    }

    func addChild(_ child: MuPodModel) {
        subModels.append(child)
        child.parent = self
    }
    
}
