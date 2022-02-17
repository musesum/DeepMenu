// Created by warren on 10/16/21.

import SwiftUI


class MuDock: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    let title: String
    var isHub: Bool = false
    var border: MuBorder

    var hub: MuHub?         // my hub; which often contains two spokes
    var spoke: MuSpoke?     // my spoke; which unfolds a hierarchy of docks
    var level: CGFloat      // zIndex within sub/super docks

    var prevDock: MuDock?   // super dock preceding this one
    var nextDock: MuDock?   // sub dock expanding from spotlight pod
    var suprPod: MuPod?     // super dock's spotlight pod
    var subPods: [MuPod]    // the pods on this dock, incl spotPod
    var podIds = Set<Int>() // set of pod.id's on this dock
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
        updateSpoke(spoke, hub)
    }

    init(prevDock: MuDock? = nil,
         suprPod: MuPod? = nil,
         subModels: [MuPodModel],
         spoke: MuSpoke? = nil,
         hub: MuHub? = nil,
         level: CGFloat = 0,
         show: Bool = true,
         axis: Axis) {

        self.prevDock = prevDock
        self.suprPod = suprPod
        self.subPods = [MuPod]()
        self.spoke = spoke
        self.hub = hub
        self.level = level
        self.title = "\(subModels.first?.title ?? "")…\(subModels.last?.title ?? "")"
        self.show = show
        
        self.border = MuBorder(type: .dock, count: subModels.count, axis: axis) //??

        prevDock?.nextDock = self

        for model in subModels {
            let pod = (subModels.count > 1) || (model.subModels?.count ?? 0 > 0)
            ? MuPod (.pod,  self, model, suprPod: suprPod)
            : MuLeaf(.rect, self, model, suprPod: suprPod)
            subPods.append(pod)
            podIds.insert(pod.id)
        }
        updateSpoke(spoke, hub)
    }
    deinit {
        // print("\n🗑\(title)(\(id))", terminator: "")=
    }

    /**
     May be updated after init for root spoke inside updateHub
     */
    func updateSpoke(_ spoke: MuSpoke?,
                     _ hub: MuHub?) {

        self.hub = hub
        guard let spoke = spoke else { return }
        self.spoke = spoke

        if let corner = hub?.corner {
            reverse = (border.vert
                       ? corner.contains(.lower) ? true : false
                       : corner.contains(.left)  ? true : false )
        }
        if let center = prevDock?.spotPod?.podXY {
            bounds = border.bounds(center)
        }
        dockShift = prevDock?.dockShift ?? .zero
    }

    func addPod(_ pod: MuPod) {

        if podIds.contains(pod.id) { return }
        podIds.insert(pod.id)
        subPods.append(pod)
    }
    
    func removePod(_ pod: MuPod) {

        if podIds.contains(pod.id) {
            podIds.remove(pod.id)
            let filtered = subPods.filter { $0.id != pod.id }
            subPods = filtered
        }
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
