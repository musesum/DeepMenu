//  Created by warren on 12/3/21.

import Foundation
/// execute a block at some time in the future
func Schedule(_ future: TimeInterval, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + future) {
        block()
    }
}
