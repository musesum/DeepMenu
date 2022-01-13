//  Created by warren on 11/24/21.

import Foundation

enum MuFlightStatus {

    case hover   // staying put or moving inward
    case explore // exploring dock or subdocks
    case change  // acting on a leaf
    case draw    // draw on canvas 

    public var description: String {
        get {
            switch self {
                case .hover   : return "⌂"
                case .explore : return "✶"
                case .change  : return "◬"
                case .draw    : return "✎"
            }
        }
    }
}
