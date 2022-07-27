//  Created by warren on 11/22/21.
import SwiftUI

enum MuBayState {

        case hide   // dock tucked into base, hidden
        case base   // docks tucked in w/ only base level shown
        case spot   // docks tucked in w/ most recent on top
        case shift  // docks shifted via user DragGesture
        case out    // docks expanded

    public var description: String { get {
        switch self {
            case .hide  : return "╶┘"
            case .base  : return "╶┤"
            case .spot  : return "╶╢"
            case .shift : return "╫╴"
            case .out   : return "╟╴"
        }}

        // hide-> base-> spot-> shift-> out -> shift -> spot -> base -> hide
    }
}

enum BaseGesture {

    case begin
    case move
    case tap
    case long
}
