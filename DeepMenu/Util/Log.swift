// Created by warren on 10/5/21.


import SwiftUI

func log(_ title: String,
         format: String = "%.0f",
         _ items: [Any],
         terminator: String = "\n") {
    var text = title
    for item in items {
        switch item {
            case let v as CGFloat:  text += String(format: "(\(format)) ", v)
            case let v as Float:    text += String(format: "(\(format)) ", v)

            case let v as CGPoint: text += String(format: "∙(\(format), \(format)) ",
                                                  v.x, v.y)
            case let v as CGSize:  text += String(format: "∘(\(format), \(format)) ",
                                                  v.width, v.height)
            case let v as CGRect:  text += String(format: "◻︎(\(format),\(format); \(format),\(format)) ",
                                                  v.origin.x, v.origin.y, v.size.width, v.size.height)

            default: break
        }
    }
    print(text, terminator: terminator)
}

func log(time: TimeInterval, _ symbol: String) {
    print(String(format: "\n%.2f \(symbol)", time), terminator: " ")
    }
