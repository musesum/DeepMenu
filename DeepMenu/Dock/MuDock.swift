// Created by warren on 10/16/21.

import SwiftUI


class MuDock: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    let title: String
    var isHub: Bool = false
    var border: MuBorder
    var spoke: MuSpoke?     // my spoke; which unfolds a hierarchy of docks
    var level: CGFloat      // zIndex within sub/super docks

    var prevDock: MuDock?   // super dock preceding this one
    var nextDock: MuDock?   // sub dock expanding from spotlight pod
    var suprPod: MuPod?     // super dock's spotlight pod
    var subPods: [MuPod]    // the pods on this dock, incl spotPod
    var spotPod: MuPod?     // current spotlight pod

    @Published var dockShift: CGSize = .zero
    @Published var bounds: CGRect = .zero
    @Published var show = true

    var reverse = false

    init(prevDock: MuDock? = nil,
         subPods: [MuPod] = [],
         spoke: MuSpoke? = nil,
         level: CGFloat = 0,
         isHub: Bool = false,
         show: Bool = true,
         axis: Axis) {

        self.prevDock = prevDock
        self.subPods = subPods
        self.spoke = spoke
        self.title = "\(subPods.first?.model.title ?? "")…\(subPods.last?.model.title ?? "")"
        self.level = level
        self.isHub = isHub
        self.show = show
        self.border = MuBorder(type: .dock, count: subPods.count, axis: axis)

        prevDock?.nextDock = self
        updateSpoke(spoke)
    }

    init(prevDock: MuDock? = nil,
         suprPod: MuPod? = nil,
         subModels: [MuPodModel],
         spoke: MuSpoke? = nil,
         level: CGFloat = 0,
         show: Bool = true,
         axis: Axis) {

        self.prevDock = prevDock
        self.suprPod = suprPod
        self.subPods = [MuPod]()
        self.spoke = spoke
        self.level = level
        self.title = "\(subModels.first?.title ?? "")…\(subModels.last?.title ?? "")"
        self.show = show
        
        self.border = MuBorder(type: .dock, count: subModels.count, axis: axis)

        prevDock?.nextDock = self

        buildSubPodsFromSubModels(subModels)
        updateSpoke(spoke)
    }
    
    deinit {
        // print("\n🗑\(title)(\(id))", terminator: "")=
    }

    // TODO: This should probably be done at the app level, as the app should be deciding e.g. if the
    //       leaf pod should be a xy rectangle control
    private func buildSubPodsFromSubModels(_ subModels: [MuPodModel]) {
        for model in subModels {
            let notLeaf = subModels.count > 1 || model.subModels.count > 0
            let pod = notLeaf ?
                MuPod (.pod,  self, model, suprPod: suprPod) : MuLeaf(.rect, self, model, suprPod: suprPod)
            subPods.append(pod)
        }
    }
    /**
     May be updated after init for root spoke inside updateHub
     */
    func updateSpoke(_ spoke: MuSpoke?) {

        guard let spoke = spoke else { return }
        self.spoke = spoke

        if let center = prevDock?.spotPod?.podXY {
            bounds = border.bounds(center)
        }
        dockShift = prevDock?.dockShift ?? .zero
    }

    func addPod(_ pod: MuPod) {
        if subPods.contains(pod) { return }
        subPods.append(pod)
    }
    
    func removePod(_ pod: MuPod) {
        let filtered = subPods.filter { $0.id != pod.id }
        subPods = filtered
    }

    func findHover(_ touchNow: CGPoint) -> MuPod? {

        // not hovering over dock? 
        if !bounds.contains(touchNow) {
            //TODO: return nil has false positives
        }

        //TODO: this is rather inefficient, is a workaround for the above
        for pod in subPods {

            if pod.podXY.distance(touchNow) < border.diameter {
                spotPod = pod
                pod.superSpotlight()
                return pod
            }
        }
        return nil
    }

    func beginTap() {

        if let spotPod = spotPod {
            spotPod.superSelect()
            spoke?.refreshDocks(self, spotPod)
        }
    }

    func updateBounds(_ fr: CGRect) {
        // if bounds != fr, let title = spotPod?.model.title { print("∿" + title, terminator: " ")}
        bounds = fr
    }
}
