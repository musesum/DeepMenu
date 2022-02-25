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

func log(_ text: String,
         _ rect1: CGRect,
         _ rect2: CGRect,
         terminator: String = "\n") {
    print(String(format: "\(text)(%.0f,%.0f; %.0f,%.0f)⟹(%.0f,%.0f; %.0f,%.0f)",
                 rect1.minX, rect1.minY, rect1.width, rect1.height,
                 rect2.minX, rect2.minY, rect2.width, rect2.height),
          terminator: terminator)

}
