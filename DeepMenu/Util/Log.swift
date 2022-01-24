// Created by warren on 10/5/21.


import SwiftUI

func log(_ text: String,
         xy: CGPoint = .zero,
         wh: CGSize = .zero,
         terminator: String = "\n") {

    let sizeStr  = (wh == .zero ? "" : String(format: " WH(%.1f, %.1f) ", wh.width, wh.height))
    let pointStr = (xy == .zero ? "" : String(format: " XY(%.1f, %.1f) ", xy.x, xy.y))
    //let pointStr = String(format: " XY(%.0f, %.0f) ", xy.x, xy.y)
    print(text + pointStr + sizeStr, terminator: terminator)
}
