//  Created by warren on 12/3/21.

import Foundation

func Delay(_ delay: TimeInterval, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        block()
    }
}
