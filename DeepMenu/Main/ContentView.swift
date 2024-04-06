// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuFlo
import MuSky

var MenuUsesDrag = true

class DeepMenuVm {
    let menuVm: MenuVm

    init() {
        let rootFlo = SkyFlo.shared.root
        let floNode = FloNode(rootFlo)
        let cornerFlo = CornerFlo(floNode, .vertical, "model_", "model", "left")
        self.menuVm = MenuVm([.lower, .left], [cornerFlo])
    }
}


struct ContentView: View {
    static let shared = ContentView()

    let deepMenuVm = DeepMenuVm()

    var body: some View {


        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.init(uiColor: .clear))
                .background(Color(white: 0.0))
                .ignoresSafeArea(.all, edges: .all)
            if MenuUsesDrag {
                MenuDragView(menuVm: deepMenuVm.menuVm)
            } else {
                TouchRepresentable([deepMenuVm.menuVm.rootVm.cornerVm])
            }
        }
        #if os(visionOS)
        .glassBackgroundEffect()
        #endif
        .statusBar(hidden: true)
    }
}

struct TouchRepresentable: UIViewRepresentable {

    typealias Context = UIViewRepresentableContext<TouchRepresentable>
    var cornerVms: [CornerVm]
    var root: Flo
    var touchesView: TouchesView

    init(_ cornerVms: [CornerVm]) {

        let touchesView = TouchesView(CGRect(x: 0, y: 0, width: 1920, height: 1280)) //????? 
        self.root = Flo("root")
        self.touchesView = touchesView
        self.cornerVms = cornerVms
        for cornerVm in cornerVms {
            CornerOpVm[cornerVm.corner.rawValue] = cornerVm
        }
    }
    public func makeUIView(context: Context) -> TouchesView {
        return touchesView
    }
    public func updateUIView(_ uiView: TouchesView, context: Context) {
        print("🔶", terminator: " ")
    }
}
