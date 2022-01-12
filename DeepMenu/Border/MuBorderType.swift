//  Created by warren on 12/21/21.

import SwiftUI

enum MuBorderType {

    case pod    // either icon or text
    case polar  // dock with 2d radians, value control
    case rect   // dock with 2d rectangular XY control
    case dock   // dock with pods
    case hub    // dock as hub for pilot

    public var description: String {
        get {
            switch self {
                case .pod   : return "z⃝"
                case .polar : return "⬈⃝"
                case .rect  : return "⬈⃞"
                case .dock  : return "⠇⃝"
                case .hub   : return "⦿⃝"
            }
        }
    }
}
