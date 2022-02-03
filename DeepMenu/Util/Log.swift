// Created by warren on 10/5/21.


import SwiftUI

func log(_ text: String,
         xy: CGPoint = .zero,
         wh: CGSize = .zero,
         terminator: String = "\n") {

    let sizeStr  = (wh == .zero ? "" : String(format: "∘(%.0f, %.0f) ", wh.width, wh.height))
    let pointStr = (xy == .zero ? "" : String(format: "∙(%.0f, %.0f) ", xy.x, xy.y))
    //let pointStr = String(format: " (x:%.0f,y:%.0f) ", xy.x, xy.y)
    print(text + pointStr + sizeStr, terminator: terminator)
}
