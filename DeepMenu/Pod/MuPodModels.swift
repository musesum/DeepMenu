// Created by warren on 10/9/21.

import Foundation

enum MuPodModels {

    
    /**
     Create a mock calendar
     */
    static func testCal(suprModel: MuPodModel? = nil,_ level: Int = 0) -> [MuPodModel] {
        let pods = [MuPodModel]()
//
//        let year = ["2022","2021"]
//        let dow = ["mon","tue","wed","thu","fri","sat","sun"]
//        let hr = ["00","01","02","03","04","05","06","07",
//                  "","","","","","","","",
//                  "","","","","","","",""]
//
//        let mm = ["jan", "feb", "mar",
//                  "apr", "may", "jun",
//                  "jul", "aug", "sep",
//                  "oct", "nov", "dec"]
//
//
//        for year in 2020...2021 {
//            for month in 1...12 {
//
//            }
//        }
        return pods
    }

    
    /**
     Create a stochastic spoke of `MuPodModel`s
     */
    static func testLetteredPods(suprModel: MuPodModel? = nil,_ level: Int = 0) -> [MuPodModel] {
        let AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let az = "abcdefghijklmnopqrstuvwxyz"
        let _09 = "0123456789"
        let ranges: [ClosedRange<Int>] = [4...6, 5...8, 5...8, 1...1]

        if level >= ranges.count { return [] }
        // A1a1a1
        let names: String = (  level == 0 ? AZ
                             : level&1 == 0 ? az
                             : _09)
        let range = ranges[level]
        let max: Int = Int.random(in: range)

        var pods = [MuPodModel]()

        for i in 0 ..< max {
            let name = names[i]
            let podModel = MuPodModel(name, suprModel: suprModel)
            let subModels = MuPodModels.testLetteredPods(suprModel: podModel, level + 1)
            podModel.subModels = subModels
            pods.append(podModel)
        }
        return pods
    }

    /**
     Create a stochastic spoke of `MuPodModel`s
     */
    // Not clear what suprModel means (supervisor? super? parent?)
    // param `spoke` here seems to be used more like `dock`, i.e. `spoke: 5` means 5 docks in this
    static func testNumberedPods(_ base: Int, spoke: Int = 0, suprModel: MuPodModel? = nil) -> [MuPodModel] {
        if spoke == 0 { return [] }
        var pods = [MuPodModel]()
        for i in 1 ... base {
            let name = String(i)
            let podModel = MuPodModel(name, suprModel: suprModel)
            let subModels = MuPodModels.testNumberedPods(base, spoke: spoke - 1, suprModel: podModel)
            podModel.subModels = subModels
            pods.append(podModel)
        }
        return pods
    }
}

