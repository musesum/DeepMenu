// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuMenuSky
import MuSkyTr3

struct ContentView: View {

    var body: some View {

        let rootTr3 = TestSkyTr3.shared.root
        let leftVm  = MenuSkyVm([.lower, .left],  .vertical, rootTr3)
        let rightVm = MenuSkyVm([.lower, .right], .vertical, rootTr3)

        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.gray)
                .ignoresSafeArea(.all, edges: .all)

            // to add UIKit touch handler, will need a ViewController
            // TouchRepresentable([leftVm.rootVm.touchVm, rightVm.rootVm.touchVm])
            // Menus without drag
            MenuDragView(menuVm: leftVm)
            MenuDragView(menuVm: rightVm)
        }
        .statusBar(hidden: true)
    }
}

struct TouchRepresentable: UIViewRepresentable {

    typealias Context = UIViewRepresentableContext<TouchRepresentable>
    var touchVms: [MuTouchVm]
    var touchView = TouchView.shared

    init(_ touchVms: [MuTouchVm]) {
        self.touchVms = touchVms
        touchView.touchVms.append(contentsOf: touchVms)
    }
    public func makeUIView(context: Context) -> TouchView {
        return touchView
    }
    public func updateUIView(_ uiView: TouchView, context: Context) {
        print("🔶", terminator: " ")
    }
}

class TouchView: UIView, UIGestureRecognizerDelegate {

    static let shared = TouchView()
    var touchKey = [String: MuTouchVm]()
    var touchVms = [MuTouchVm]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        isMultipleTouchEnabled = true
    }

    // MARK: - Touches

    func updateTouches(_ touches: Set<UITouch>, _ event: UIEvent?) {
        
        for touch in touches {

            let touchXY = ((touch.phase == .ended ||
                            touch.phase == .cancelled)
                           ? .zero
                           : touch.preciseLocation(in: nil))

            let key = String(format: "%p", touch)

            if let touchVm = touchKey[key] {

                touchVm.touchMenuUpdate(touchXY)

            } else {

                for touchVm in touchVms {
                    if  touchVm.hitTest(touchXY) {

                        touchVm.touchMenuUpdate(touchXY)
                        touchKey[key] = touchVm
                        break
                    }
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouches(touches, event) }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouches(touches, event) }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouches(touches, event) }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouches(touches, event) }

}
