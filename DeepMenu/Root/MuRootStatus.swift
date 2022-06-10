//  Created by warren on 11/24/21.

import Foundation

enum MuRootStatus: String  {
    
    case root   // only root node showing
    case tree   // branches expanded, hovering
    case edit   // editing a leaf
    case space  // hovering over canvas
    
    public var symbol: String {
        switch self {
            case .root  : return "√"
            case .tree  : return "𐂷"
            case .edit  : return "✎"
            case .space : return "⬚"
        }
    }
    public var description: String {
        switch self {
            case .root  : return "root"
            case .tree  : return "tree"
            case .edit  : return "edit"
            case .space : return "space"
        }
    }
}
