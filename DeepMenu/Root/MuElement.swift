//  Created by warren on 11/24/21.

import Foundation

enum MuElement: String  {
    
    case none   // starting point before showing 
    case home   // only root node showing
    case branch // branches expanded for one tree, hovering
    case trunks // only first branch of multiple trees
    case node   // over a specific node
    case leaf   // dragable header for leaf
    case edit   // editing area inside a leaf
    case space  // hovering over canvas
    case edge   // unsafe area to expand accordian
    
    public var symbol: String {
        switch self {
            case .none   : return "⋄"
            case .home   : return "⌂"
            case .trunks : return "ᛘ"
            case .branch : return "𐂷"
            case .node   : return "￮"
            case .leaf   : return "⚘"
            case .edit   : return "✎"
            case .space  : return "⬚"
            case .edge   : return "⫼"
        }
    }
    public var description: String {
        switch self {
            case .none   : return "none"
            case .home   : return "home"
            case .trunks : return "trunks"
            case .branch : return "branch"
            case .node   : return "node"
            case .leaf   : return "leaf"
            case .edit   : return "edit"
            case .space  : return "space"
            case .edge   : return "edge"
        }
    }
    static public func symbols(_ set: Set<MuElement>) -> String {
        var result = "〈"
        for item in set {
            result += item.symbol
        }
        result += "〉"
        return result
    }
}

