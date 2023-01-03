// Created by warren on 10/9/21.

import Foundation
import MuMenu

enum ExampleNodeModels {

    /**
     Create a mock calendar
     */
    static func calendarNodes(parent: MuCornerNode? = nil,
                             _ level: Int = 0) -> [MuCornerNode] {
        let nodes = [MuCornerNode]()
        //TODO: setup random points in timeline
        return nodes
    }

    /**
     Create a stochastic tree of `MuCornerNode`s
     */
    static func letteredNodes(parent: MuCornerNode? = nil, _ level: Int = 0) -> [MuCornerNode] {
        var nodes = [MuCornerNode]()
        let AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let az = "abcdefghijklmnopqrstuvwxyz"
        let hex = "0123456789ABCDEF"
        let values: [ClosedRange<Int>] = [4...6, 5...12, 5...8, 1...1]

        if level >= values.count { return [] }
        // A1a1a1
        let names: String = (  level == 0 ? AZ
                               : level&1 == 0 ? az
                               : hex)
        let value = values[level]
        let max: Int = Int.random(in: value)

        for i in 0 ..< max {
            let name = names[i]
            let nodeType: MuMenuType = (level == values.count - 1 ? .vxy : .node)
            let nodeModel = MuCornerNode(name, type: nodeType, parent: parent)
            let children = ExampleNodeModels.letteredNodes(parent: nodeModel, level + 1)
            nodeModel.children = children
            nodes.append(nodeModel)
        }
        return nodes
    }
    /**
     Recursively creates a stochastic array of Node trees using numbers as the base naming.
     Example: testNumberedNodes(3, numLevels: 2) would create e.g [1 => [11, 12, 13], 2 => [21, 22, 23], 3 => [31, 32, 33]]
     representing 2 Branches of Nodes with 3 Nodes in each Branch

     - Parameters:
       - count: The number of nodes per level (the same for all levels).
       - numLevels: How many sub-node levels, including the initial one.
       - parent: The parent MuCornerNode for this level .... TODO: not clear what parent means (supervisor? super? parent?)
     - Returns: An array of number-styled MuCornerNodes
     */
    static func numberedNodes(_ count: Int, numLevels: Int = 0, parent: MuCornerNode? = nil) -> [MuCornerNode] {
        var nodes = [MuCornerNode]()

        if numLevels > 0 {

            for i in 1 ... count {
                let name = String(i)
                let nodeModel = MuCornerNode(name, parent: parent)
                let children = ExampleNodeModels.numberedNodes(count, numLevels: numLevels - 1, parent: nodeModel)
                nodeModel.children = children
                nodes.append(nodeModel)
            }
        }
        return nodes
    }
}

