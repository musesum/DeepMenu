//  Created by warren on 12/21/21.

import SwiftUI

public enum MuNodeType: String {
    case none // no defined thpe
    case node // either icon or text
    case val  // value control
    case vxy  // value XY control
    case tog  // toggle on/off
    case tap  // tap a button
    case seg  // segment control
    
    public var description: String {
        switch self {
            case .none : return "none"
            case .node : return "node"
            case .val  : return "val"
            case .vxy  : return "vxy"
            case .tog  : return "tog"
            case .seg  : return "seg"
            case .tap  : return "tap"
        }
    }
    public var name: String {
        return description
    }
    public var icon: String {
        switch self {
            case .none : return " ⃝"
            case .node : return "ᛘ⃝"
            case .val  : return "≣⃝"
            case .vxy  : return "᛭⃣"
            case .tog  : return "◧⃝"
            case .seg  : return "◔⃝"
            case .tap  : return "◉⃝"
        }
    }


    init(_ name: String) {

        switch name {
            case "none" : self = .none
            case "node" : self = .node
            case "val"  : self = .val
            case "vxy"  : self = .vxy
            case "tog"  : self = .tog
            case "seg"  : self = .seg
            case "tap"  : self = .tap
            default     : self = .none
        }
    }
    var isLeaf: Bool {
        switch self {
            case .node, .none: return false
            default: return true
        }
    }

}

public let MuNodeLeaves = Set<String>(["val", "vxy", "tog", "seg", "tap"])
