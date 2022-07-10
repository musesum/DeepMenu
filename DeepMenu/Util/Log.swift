// Created by warren on 10/5/21.


import SwiftUI

func log(_ title: String,
         format: String = "%.0f",
         _ items: [Any] = [],
         length: Int = 0,
         terminator: String = "\n") {

    var text = title
    for item in items {
        switch item {
            case let v as CGFloat : text += String(format: "(\(format)) ", v)
            case let v as Float   : text += String(format: "(\(format)) ", v)
            case let v as CGPoint : text += String(format: "∙(\(format), \(format)) ", v.x, v.y)
            case let v as CGSize  : text += String(format: "∘(\(format), \(format)) ",
                                                   v.width, v.height)
            case let v as CGRect  : text += String(format: "▭(\(format),\(format); \(format),\(format)) ", v.origin.x, v.origin.y, v.size.width, v.size.height)

            case let v as MuElement: text += "\(v.symbol)"
            case let v as Set<MuElement>: text += "\(MuElement.symbols(v))"
            case let v as String: text += v

            case let (x,y) as RangeXY:

                let xs = String(format: "%.0f…%.0f", x.lowerBound, x.upperBound)
                let ys = String(format: "%.0f…%.0f", y.lowerBound, y.upperBound)
                let xPad = String(format: "%@", xs)// xs.padding(toLength: 8, withPad: " ", startingAt: 0)
                let yPad = String(format: "%@", ys)//ys.padding(toLength: 8, withPad: " ", startingAt: 0)
                text += "(\(xPad) \(yPad))"

            default: break
        }
    }
    if length > 0 {
       print(text.padding(toLength: length, withPad: " ", startingAt: 0), terminator: " ")
    } else {
        print(text, terminator: terminator)
    }

}

func log(time: TimeInterval,
         _ symbol: String) {

    print(String(format: "\n%.2f \(symbol)", time), terminator: " ")
}
