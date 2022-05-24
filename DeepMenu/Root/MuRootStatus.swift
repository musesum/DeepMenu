//  Created by warren on 11/24/21.

import Foundation

enum MuRootStatus: String  {

    case root    // unknown at beginning
    case limb  // over a limb's branch
    case space  // neither hori or vert


    public var description: String {
        get {
            switch self {
                case .root  : return "⦿"
                case .limb  : return "⌖"
                case .space : return "⬚"
            }
        }
    }
}

