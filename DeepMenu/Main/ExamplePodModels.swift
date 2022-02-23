// Created by warren on 10/9/21.

import Foundation

enum ExamplePodModels {

    /**
     Create a mock calendar
     */
    static func calendarPods(suprModel: MuPodModel? = nil,
                             _ level: Int = 0) -> [MuPodModel] {
        let pods = [MuPodModel]()
        //TODO: setup random points in timeline
        return pods
    }

    /**
     Create a stochastic spoke of `MuPodModel`s
     */
    static func letteredPods(suprModel: MuPodModel? = nil,
                             _ level: Int = 0) -> [MuPodModel] {
        var pods = [MuPodModel]()
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
            let podModel = MuPodModel(name, suprModel: suprModel)
            let subModels = ExamplePodModels.letteredPods(suprModel: podModel, level + 1)
            podModel.subModels = subModels
            pods.append(podModel)
        }
        return pods
    }
    /**
     Recursively creates a stochastic array of Pod trees using numbers as the base naming.
     Example: testNumberedPods(3, numLevels: 2) would create e.g [1 => [11, 12, 13], 2 => [21, 22, 23], 3 => [31, 32, 33]]
     representing 2 Docks of Pods with 3 Pods in each Dock

     - Parameters:
       - count: The number of pods per level (the same for all levels).
       - numLevels: How many sub-pod levels, including the initial one.
       - suprModel: The parent MuPodModel for this level .... TODO: not clear what suprModel means (supervisor? super? parent?)
     - Returns: An array of number-styled MuPodModels
     */
    static func numberedPods(_ count: Int, numLevels: Int = 0, suprModel: MuPodModel? = nil) -> [MuPodModel] {
        var pods = [MuPodModel]()

        if numLevels > 0 {

            for i in 1 ... count {
                let name = String(i)
                let podModel = MuPodModel(name, suprModel: suprModel)
                let subModels = ExamplePodModels.numberedPods(count, numLevels: numLevels - 1, suprModel: podModel)
                podModel.subModels = subModels
                pods.append(podModel)
            }
        }
        return pods
    }
}

