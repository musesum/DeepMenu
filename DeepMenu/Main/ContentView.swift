// Created 9/26/21.
import SwiftUI
import MuFlo
import MuMenu
import MuVision
import MuHands
import MuSky

@MainActor
class DeepMenuVm {
    let root˚: Flo
    let archiveFlo: ArchiveFlo
    let archiveVm: ArchiveVm
    let handsPhase: HandsPhase
    let menus: Menus
    let menuView: MenuView

    init() {
        // Reconstruct the same Flo data tree DeepMuse uses by loading the
        // .flo.h scripts from the MuSky + MuVision bundles. No render pipeline
        // here — ArchiveFlo only populates the Flo graph that backs the menus.
        // Script list mirrors DeepMuse/Sky/SkyArchive.swift.
        let root˚ = Flo("√")
        self.root˚ = root˚

        let bundles = [MuSky.bundle, MuVision.bundle]
        let scriptNames = ["sky", "draw", "pipe", "canvas", "brush", "plato",
                           "cell", "camera", "more", "hand", "chat", "midi", "tape"]
        self.archiveFlo = ArchiveFlo(root˚, bundles, "Snapshot", scriptNames)

        self.archiveVm = ArchiveVm()
        self.handsPhase = HandsPhase(root˚)
        self.menus = Menus(root˚, archiveVm, handsPhase)
        self.menuView = MenuView(menus.menuVms)
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
            deepMenuVm.menuView
        }
        #if os(visionOS)
        .glassBackgroundEffect()
        #endif
        .statusBar(hidden: true)
    }
}
