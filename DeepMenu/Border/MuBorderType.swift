//  Created by warren on 12/21/21.

import SwiftUI

enum MuBorderType {

    case node    // either icon or text
    case slider // branch with 1d slider
    case polar  // branch with 2d radians, value control
    case rect   // branch with 2d rectangular XY control
    case branch   // branch with nodes
    case root    // branch as root for pilot

    public var description: String {
        get {
            switch self {
                case .node    : return "z⃝"
                case .slider : return "-⃝"
                case .polar  : return "⬈⃝"
                case .rect   : return "◆⃣"
                case .branch   : return "⠇⃝"
                case .root    : return "●⃝"
            }
        }
    }
}
