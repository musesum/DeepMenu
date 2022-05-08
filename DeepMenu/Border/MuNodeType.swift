//  Created by warren on 12/21/21.

import SwiftUI

enum MuNodeType: String {
    case none // no defined thpe
    case node // either icon or text
    case dial // branch with 2d radians, value control
    case box  // branch with 2d rectangular XY control
    case tog  // toggle on/off
    case pad  // drum pad (trigger)
    case seg  // segment control

    public var description: String {
        get {
            switch self {
                case .none : return "none"
                case .node : return "node"
                case .dial : return "dial"
                case .box  : return "box"
                case .tog  : return "tog"
                case .seg  : return "seg"
                case .pad  : return "pad"
            }
        }
    }
    public var bug: String {
        get {
            switch self {
                case .none : return " ⃝"
                case .node : return "ᛘ⃝"
                case .dial : return "⟳⃝"
                case .box  : return "᛭⃣"
                case .tog  : return "◧⃝"
                case .seg  : return "◔⃝"
                case .pad  : return "◉⃝"
            }
        }
    }
    init(_ name: String) {
        switch name {
            case "none" : self = .none
            case "node" : self = .node
            case "dial" : self = .dial
            case "box"  : self = .box
            case "tog"  : self = .tog
            case "seg"  : self = .pad
            case "pad"  : self = .seg
            default     : self = .none
        }
    }
    var isLeaf: Bool { get {
        switch self {
            case .node, .none: return false
            default: return true
        }
    }}

}
