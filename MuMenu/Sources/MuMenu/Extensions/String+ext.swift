// Created by warren on 10/16/21.


import Foundation

extension String {
    public subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    public func pad(_ len: Int) -> String {
        padding(toLength: len, withPad: " ", startingAt: 0)
    }
}
public func superScript(_ num: Int) -> String {
    var s = ""
    let numStr = String(num)
    for n in numStr.utf8 {
        let i = Int(n) - 48 // utf8 for '0'
        s += "⁰¹²³⁴⁵⁶⁷⁸⁹"[i]
    }
    return s
}
