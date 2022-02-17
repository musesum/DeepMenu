// Created by warren on 10/17/21.

import SwiftUI

class MuPod: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()

    static func == (lhs: MuPod, rhs: MuPod) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var spotlight = false // true when selected or under cursor
    var spotTime = TimeInterval(0)

    var model: MuPodModel
    var icon: String
    var dock: MuDock
    var suprPod: MuPod?    // super pod
    var subPods: [MuPod]  // sub pods
    var podXY = CGPoint.zero // current position

    var border: MuBorder

    init (_ type: MuBorderType,
          _ dock: MuDock,
          _ model: MuPodModel,
          icon: String = "",
          suprPod: MuPod? = nil,
          subPods: [MuPod] = []) {

        self.dock = dock
        self.model = model
        self.icon = icon
        self.suprPod = suprPod
        self.subPods = subPods
        self.border = MuBorder(type: type)

        if [.polar, .rect].contains(type) {
            dock.border.type = type
        }

        if let subModels = model.subModels {
            for subModel in subModels {
                let subPod = MuPod(type, dock, subModel, suprPod: self)
                self.subPods.append(subPod)
            }
        }
    }
    
    func copy(diameter: CGFloat) -> MuPod {
        let pod = MuPod(border.type, dock, model,
                        icon: icon,
                        suprPod: self,
                        subPods: subPods)
        return pod
    }

    /// spotlight self, parent, grand, etc. in dock
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for pod in dock.subPods {
            pod.spotlight = false
        }
        spotlight = true
        spotTime = time
        suprPod?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in dock
    func superSelect() {

        if let suprPod = suprPod {
            suprPod.spotlight = true
            suprPod.model.subNow = model
            suprPod.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {

        let center = CGPoint(x: fr.origin.x + fr.size.width/2,
                             y: fr.origin.y + fr.size.height/2)
        podXY = center
    }

}
