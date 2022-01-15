//  Created by warren on 11/15/21.

import Foundation

enum MuFlightAbove: String  {
    
    case hub    // unknown at beginning
    case space  // neither hori or vert
    case spoke  // over a spoke's dock

    public var description: String {
        get {
            switch self {
                case .hub : return "⦿"    //❂
                case .spoke : return "⌖" // ✢
                case .space: return "⬚"  // 🔭
            }
        }
    }
}

