// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuFlo
import MuMenuSky
import MuSkyFlo

var MenuUsesDrag = true

struct ContentView: View {
    static let shared = ContentView()

    var body: some View {

        let rootFlo = TestSkyFlo.shared.root
        let rootNode = FloNode(rootFlo)
        let leftVm  = MenuVm([.lower, .left],  [(rootNode, .vertical),
                                                (rootNode, .horizontal)])

        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.init(uiColor: .clear))
                .background(Color(white: 0.0))
                .ignoresSafeArea(.all, edges: .all)
            if MenuUsesDrag {
                MenuDragView(menuVm: leftVm)
            } else {
                TouchRepresentable([leftVm.rootVm.cornerVm])
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
