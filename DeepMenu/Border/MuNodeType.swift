//  Created by warren on 12/21/21.

import SwiftUI

enum MuNodeType: String {
    case none // no defined thpe
    case node // either icon or text
    case sldr // slider control
    case boxy // branch with 2d rectangular XY control
    case togl // toggle on/off
    case tap  // drum pad (trigger)
    case sgmt // segment control

    public var description: String {
        get {
            switch self {
                case .none : return "none"
                case .node : return "node"
                case .sldr : return "sldr"
                case .boxy : return "boxy"
                case .togl : return "togl"
                case .sgmt : return "sgmt"
                case .tap  : return "tap"
            }
        }
    }
    public var bug: String {
        get {
            switch self {
                case .none : return " ⃝"
                case .node : return "ᛘ⃝"
                case .sldr : return "≣⃝"
                case .boxy : return "᛭⃣"
                case .togl : return "◧⃝"
                case .sgmt : return "◔⃝"
                case .tap  : return "◉⃝"
            }
        }
    }
    init(_ name: String) {
        switch name {
            case "none" : self = .none
            case "node" : self = .node
            case "sldr" : self = .sldr
            case "boxy" : self = .boxy
            case "togl" : self = .togl
            case "sgmt" : self = .sgmt
            case "tap"  : self = .tap
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
