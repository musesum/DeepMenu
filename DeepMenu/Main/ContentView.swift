// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuFlo
import MuMenuSky
import MuSkyFlo

var MenuUsesDrag = true

struct ContentView: View {

    var body: some View {

        let rootFlo = TestSkyFlo.shared.root
        let rootNode = MuFloNode(rootFlo)
        let leftVm  = MenuVm([.lower, .left],  [(rootNode, .vertical),
                                                (rootNode, .horizontal)])

        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.init(uiColor: .clear))
                .ignoresSafeArea(.all, edges: .all)
            if MenuUsesDrag {
                MenuDragView(menuVm: leftVm)
            } else {
                //TouchRepresentable([leftVm.rootVm.touchVm])
            }
        }
        .statusBar(hidden: true)
    }
}

#if os(iOS)
struct TouchRepresentable: UIViewRepresentable {

    typealias Context = UIViewRepresentableContext<TouchRepresentable>
    var touchVms: [MuTouchVm]
    var root: Flo
    var touchView: TouchView

    init(_ touchVms: [MuTouchVm]) {

        let touchView = TouchView(CGRect(x: 0, y: 0, width: 1920, height: 1280))
        self.root = Flo("root")
        self.touchView = touchView
        self.touchVms = touchVms
        for touchVm in touchVms {
            CornerTouchVm[touchVm.corner.rawValue] = touchVm
        }
    }
    public func makeUIView(context: Context) -> TouchView {
        return touchView
    }
    public func updateUIView(_ uiView: TouchView, context: Context) {
        print("🔶", terminator: " ")
    }
}
#endif
