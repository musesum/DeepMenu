//  Created by warren on 12/21/21.

import SwiftUI

enum MuNodeType {
    case none   // no defined thpe
    case node   // either icon or text
    case slide  // branch with 1d slider
    case knob   // branch with 2d radians, value control
    case boxy   // branch with 2d rectangular XY control
    case togl   // toggle on/off
    case drum   // drum pad (trigger)
    case segmt  // segment control

    public var description: String {
        get {
            switch self {
                case .none  : return " ⃝"
                case .node  : return "⑂⃝"
                case .slide : return "⬌⃝"
                case .knob  : return "⟳⃝"
                case .boxy  : return "᛭⃣"
                case .togl  : return "◑⃝"
                case .segmt : return "꠲⃝"
                case .drum  : return "◉⃝"
            }
        }
    }
    init(_ name: String) {
        switch name {
            case "none"  : self = .none
            case "node"  : self = .node
            case "slide" : self = .slide
            case "knob"  : self = .knob
            case "boxy"  : self = .boxy
            case "togl"  : self = .togl
            case "segmt" : self = .segmt
            case "drum " : self = .slide
            default      : self = .none
        }
    }
    var isLeaf: Bool { get {
        switch self {
            case .slide, .knob, .boxy, .togl, .segmt, .drum: return true
            default: return false
        }
    }}

}
