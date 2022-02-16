//  Created by warren on 11/24/21.

import Foundation

enum MuHubStatus: String  {

    case hub    // unknown at beginning
    case spoke  // over a spoke's dock
    case space  // neither hori or vert


    public var description: String {
        get {
            switch self {
                case .hub   : return "⦿"
                case .spoke : return "⌖"
                case .space : return "⬚"
            }
        }
    }
}

