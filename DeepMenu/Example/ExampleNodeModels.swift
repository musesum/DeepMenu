// Created by warren on 10/9/21.

import Foundation

enum ExampleNodeModels {

    /**
     Create a mock calendar
     */
    static func calendarNodes(suprModel: MuNodeModel? = nil,
                             _ level: Int = 0) -> [MuNodeModel] {
        let nodes = [MuNodeModel]()
        //TODO: setup random points in timeline
        return nodes
    }

    /**
     Create a stochastic limb of `MuNodeModel`s
     */
    static func letteredNodes(suprModel: MuNodeModel? = nil, _ level: Int = 0) -> [MuNodeModel] {
        var nodes = [MuNodeModel]()
        let AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let az = "abcdefghijklmnopqrstuvwxyz"
        let hex = "0123456789ABCDEF"
        let ranges: [ClosedRange<Int>] = [4...6, 5...12, 5...8, 1...1]

        if level >= ranges.count { return [] }
        // A1a1a1
        let names: String = (  level == 0 ? AZ
                               : level&1 == 0 ? az
                               : hex)
        let range = ranges[level]
        let max: Int = Int.random(in: range)

        for i in 0 ..< max {
            let name = names[i]
            let borderType: MuBorderType = (level == ranges.count - 1 ? .rect : .node)
            let nodeModel = MuNodeModel(name, type: borderType, suprModel: suprModel)
            let subModels = ExampleNodeModels.letteredNodes(suprModel: nodeModel, level + 1)
            nodeModel.subModels = subModels
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
       - suprModel: The parent MuNodeModel for this level .... TODO: not clear what suprModel means (supervisor? super? parent?)
     - Returns: An array of number-styled MuNodeModels
     */
    static func numberedNodes(_ count: Int, numLevels: Int = 0, suprModel: MuNodeModel? = nil) -> [MuNodeModel] {
        var nodes = [MuNodeModel]()

        if numLevels > 0 {

            for i in 1 ... count {
                let name = String(i)
                let nodeModel = MuNodeModel(name, suprModel: suprModel)
                let subModels = ExampleNodeModels.numberedNodes(count, numLevels: numLevels - 1, suprModel: nodeModel)
                nodeModel.subModels = subModels
                nodes.append(nodeModel)
            }
        }
        return nodes
    }
}

