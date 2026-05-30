import SwiftUI
import WatchKit
import AVFoundation
import MuFlo
import MuMenu

@MainActor
class DeepWatchVm {
    let root˚: Flo
    let archiveVm: ArchiveVm
    let handsPhase: HandsPhase
    let menus: Menus
    let menuView: MenuView
    var cornerVms: [CornerVm] { menus.menuVms.map { $0.rootVm.cornerVm } }

    init() {
        let root˚ = Flo("√")
        self.root˚ = root˚

        let scriptNames = ["sky", "draw", "pipe", "canvas", "brush", "plato",
                           "cell", "camera", "more", "hand", "chat", "midi", "tape"]
        for name in scriptNames {
            if let url = Bundle.main.url(forResource: name, withExtension: "flo.h"),
               let script = try? String(contentsOf: url, encoding: .utf8) {
                _ = FloParse().parseRoot(root˚, script)
            }
        }
        root˚.bindPolicy()

        self.archiveVm = ArchiveVm()
        self.handsPhase = HandsPhase(root˚)
        self.menus = Menus(root˚, archiveVm, handsPhase)
        self.menuView = MenuView(menus.menuVms)
    }
}

@MainActor
final class WatchFeedback {

    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    private var prepared = false

    private let siblingBaseHz: Double = 880
    private var lineageBaseHz: Double { siblingBaseHz / 2 }
    private let semitone: Double = pow(2.0, 1.0 / 7.0)

    init() {
        engine.attach(mixer)
        engine.connect(mixer, to: engine.mainMixerNode, format: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            prepared = true
        } catch {
            prepared = false
        }
    }

    func sibling(index: Int, count: Int) {
        WKInterfaceDevice.current().play(.click)
        let position = Double(max(0, count - 1 - index))
        playTone(hz: siblingBaseHz * pow(semitone, position))
    }
    func child(depth: Int) {
        WKInterfaceDevice.current().play(.directionUp)
        playTone(hz: lineageBaseHz * pow(semitone, Double(depth)))
    }
    func parent(depth: Int) {
        WKInterfaceDevice.current().play(.directionDown)
        playTone(hz: lineageBaseHz * pow(semitone, Double(depth)))
    }

    private func playTone(hz: Double, duration: TimeInterval = 0.06) {
        guard prepared else { return }
        let format = mixer.outputFormat(forBus: 0)
        let sampleRate = format.sampleRate
        let frames = AVAudioFrameCount(sampleRate * duration)
        guard let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames) else { return }
        buf.frameLength = frames
        let channels = Int(format.channelCount)
        let twoPiF = 2.0 * .pi * hz / sampleRate
        if let chData = buf.floatChannelData {
            for f in 0..<Int(frames) {
                let frac = Float(f) / Float(frames)
                let env: Float = frac < 0.1 ? frac * 10
                              : frac > 0.8 ? (1.0 - frac) * 5
                              : 1.0
                let sample = Float(sin(Double(f) * twoPiF)) * 0.3 * env
                for c in 0..<channels { chData[c][f] = sample }
            }
        }
        let player = AVAudioPlayerNode()
        engine.attach(player)
        engine.connect(player, to: mixer, format: format)
        player.scheduleBuffer(buf, completionHandler: nil)
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) { [weak self, weak player] in
            guard let self, let player else { return }
            player.stop()
            self.engine.detach(player)
        }
    }
}

@MainActor
final class FeedbackBox: ObservableObject {
    let value = WatchFeedback()
}

/// Nine begin-touch zones for leaf controller gesture mode selection.
private enum OriginCell {
    case NW, N, NE
    case W,  C, E
    case SW, S, SE

    static func cell(of point: CGPoint, in size: CGSize) -> OriginCell {
        let col = point.x < size.width * 1.0/3.0 ? 0 : point.x < size.width * 2.0/3.0 ? 1 : 2
        let row = point.y < size.height * 1.0/3.0 ? 0 : point.y < size.height * 2.0/3.0 ? 1 : 2
        switch (row, col) {
        case (0, 0): return .NW
        case (0, 1): return .N
        case (0, 2): return .NE
        case (1, 0): return .W
        case (1, 1): return .C
        case (1, 2): return .E
        case (2, 0): return .SW
        case (2, 1): return .S
        case (2, 2): return .SE
        default:     return .C
        }
    }

    var isCorner: Bool {
        switch self {
        case .NW, .NE, .SW, .SE: return true
        default: return false
        }
    }
}

private struct LeafPlaceholder: View {
    let cornerType: MenuCorner

    var alignment: Alignment {
        switch cornerType {
        case .NW: return .topLeading
        case .NE: return .topTrailing
        case .SW: return .bottomLeading
        case .SE: return .bottomTrailing
        case .none: return .center
        }
    }

    var body: some View {
        ZStack(alignment: alignment) {
            Color.clear
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.08)))
                .frame(width: Menu.diameter, height: Menu.diameter)
                .padding(Menu.padding2)
        }
    }
}

/// Full-face leaf editor. Touch coordinates map to runway values using the
/// actual runway bounds stored by LeafBezelView (global visual space).
/// Zone assignment from the 9-cell grid at touch-begin:
///   N/S  → X (horizontal position → xNorm)
///   W    → Y (vertical, inverted → yNorm)
///   E    → Y or Z for XYZ
///   C    → XY pad (both axes)
///   corners → exit after 8pt movement threshold
private struct WatchLeafController: View {
    let leafVm: LeafVm
    let onExit: () -> Void
    let onValueLive: (String?) -> Void

    @State private var dragOrigin: OriginCell? = nil
    @State private var exitTriggered: Bool = false

    private var isXyz: Bool { leafVm is LeafXyzVm }

    private var naturalLeafSize: CGSize {
        let d = Menu.diameter
        let row1W = 2 + d + 4 + d * 2.5
        let row1H = 2 + d
        let row2W: CGFloat = isXyz
            ? (d * 0.5 + 4 + d * 3.0 + 4 + d * 0.5)
            : (d * 0.5 + 4 + d * 3.0)
        let row2H = d * 3.0
        return CGSize(width: max(row1W, row2W), height: row1H + row2H)
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let scale = leafScale(in: size)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.95))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1))
                    .frame(width: size.width, height: size.height)

                Group {
                    if let xy = leafVm as? LeafXyVm {
                        LeafXyView(leafVm: xy)
                    } else if let xyz = leafVm as? LeafXyzVm {
                        LeafXyzView(leafVm: xyz)
                    }
                }
                .frame(width: naturalLeafSize.width, height: naturalLeafSize.height)
                .scaleEffect(scale, anchor: .topLeading)
            }
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in handleDrag(value: value, in: size) }
                    .onEnded { _ in
                        dragOrigin = nil
                        exitTriggered = false
                        onValueLive(nil)
                    }
            )
        }
    }

    private func leafScale(in size: CGSize) -> CGFloat {
        let sx = size.width  / max(1, naturalLeafSize.width)
        let sy = size.height / max(1, naturalLeafSize.height)
        return min(sx, sy)
    }

    /// Classify which runway (or corner) a touch-begin point belongs to.
    /// Runway membership is checked before the 3×3 grid so the XY pad, which
    /// is larger than the center grid cell, is always assigned .C regardless
    /// of which quadrant of the runway the finger lands on.
    private func classifyOrigin(_ pt: CGPoint, scale s: CGFloat, in size: CGSize) -> OriginCell {
        if scaledBounds(.runXY, s).contains(pt) { return .C }
        if scaledBounds(.runY,  s).contains(pt) { return .W }
        if isXyz && scaledBounds(.runZ, s).contains(pt) { return .E }
        if scaledBounds(.runX,  s).contains(pt) { return .N }
        return OriginCell.cell(of: pt, in: size)
    }

    private func handleDrag(value: DragGesture.Value, in size: CGSize) {
        let s = leafScale(in: size)
        if dragOrigin == nil {
            dragOrigin = classifyOrigin(value.startLocation, scale: s, in: size)
        }
        guard let origin = dragOrigin else { return }

        if origin.isCorner {
            let mag = hypot(value.translation.width, value.translation.height)
            if mag > 8 && !exitTriggered {
                exitTriggered = true
                onExit()
            }
            return
        }

        // value.location is ZStack-local visual space; scaledBounds converts natural
        // runway rects to the same visual space via scaleEffect(scale, anchor:.topLeading).
        func normX(_ type: LeafRunwayType) -> Double {
            let b = scaledBounds(type, s)
            return ((Double(value.location.x) - Double(b.minX)) / Double(b.width)).clamped(to: 0...1)
        }
        func normY(_ type: LeafRunwayType) -> Double {
            let b = scaledBounds(type, s)
            return 1.0 - ((Double(value.location.y) - Double(b.minY)) / Double(b.height)).clamped(to: 0...1)
        }

        switch origin {
        case .N, .S: leafVm.setNormalized([("x", normX(.runX))])
        case .W:     leafVm.setNormalized([("y", normY(.runY))])
        case .E:
            let type: LeafRunwayType = isXyz ? .runZ : .runY
            leafVm.setNormalized([(isXyz ? "z" : "y", normY(type))])
        case .C:     leafVm.setNormalized([("x", normX(.runXY)), ("y", normY(.runXY))])
        default: break
        }
        onValueLive(leafVm.treeTitle())
    }

    /// Natural runway rect × scale → ZStack-local visual coordinates, matching value.location.
    private func scaledBounds(_ type: LeafRunwayType, _ s: CGFloat) -> CGRect {
        let nat = naturalBounds(type)
        return CGRect(x: nat.minX * s, y: nat.minY * s,
                      width: nat.width * s, height: nat.height * s)
    }

    /// Runway positions in ZStack-local natural (pre-scale) layout space.
    private func naturalBounds(_ type: LeafRunwayType) -> CGRect {
        let d     = Menu.diameter
        let vSpc  = CGFloat(4)
        let lead  = CGFloat(2)
        let row1H = lead + d
        let row2T = row1H
        let row2H = d * 3
        let natW  = naturalLeafSize.width
        let row2W: CGFloat = isXyz ? (d*0.5 + vSpc + d*3 + vSpc + d*0.5)
                                   : (d*0.5 + vSpc + d*3)
        let vstOff = (natW - row2W) / 2
        let row1W  = lead + d + vSpc + d * 2.5
        let r1Off  = (natW - row1W) / 2
        let row1Mid = row1H / 2
        switch type {
        case .runX:
            let bh = d * 0.5
            return CGRect(x: r1Off + lead + d + vSpc, y: row1Mid - bh/2, width: d*2.5, height: bh)
        case .runY:
            let bh = d * 2.5
            return CGRect(x: vstOff, y: row2T + (row2H-bh)/2, width: d*0.5, height: bh)
        case .runXY:
            return CGRect(x: vstOff + d*0.5 + vSpc, y: row2T, width: d*3, height: d*3)
        case .runZ:
            let bh = d * 2.5
            return CGRect(x: vstOff + d*0.5 + vSpc + d*3 + vSpc,
                          y: row2T + (row2H-bh)/2, width: d*0.5, height: bh)
        default: return .zero
        }
    }
}

/// Full-face controller for a single vertical (Y) parameter.
/// A horizontal bar spanning the full screen width tracks the value;
/// dragging anywhere up/down updates it. Corner drag exits.
private struct WatchLeafYController: View {
    @ObservedObject var leafVm: LeafValVm
    let onExit: () -> Void
    let onValueLive: (String?) -> Void

    @State private var dragOrigin: OriginCell? = nil
    @State private var exitTriggered: Bool = false

    var body: some View {
        GeometryReader { geo in
            let size  = geo.size
            let yVal  = leafVm.valNorm
            let barH  = CGFloat(8)
            let barY  = CGFloat(1 - yVal) * max(0, size.height - barH)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.95))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1))
                    .frame(width: size.width, height: size.height)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.85))
                    .frame(width: size.width - 16, height: barH)
                    .offset(x: 8, y: barY)
            }
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in handleDrag(value: value, in: size) }
                    .onEnded { _ in
                        dragOrigin = nil
                        exitTriggered = false
                        onValueLive(nil)
                    }
            )
        }
    }

    private func handleDrag(value: DragGesture.Value, in size: CGSize) {
        if dragOrigin == nil {
            dragOrigin = OriginCell.cell(of: value.startLocation, in: size)
        }
        guard let origin = dragOrigin else { return }

        if origin.isCorner {
            let mag = hypot(value.translation.width, value.translation.height)
            if mag > 8 && !exitTriggered { exitTriggered = true; onExit() }
            return
        }
        let ny = 1.0 - Double(value.location.y / size.height).clamped(to: 0...1)
        leafVm.setValNormalized(ny)
        onValueLive(leafVm.treeTitle())
    }
}

struct ContentView: View {

    let vm = DeepWatchVm()
    @StateObject private var feedback = FeedbackBox()
    @State private var activeCornerVm: CornerVm? = nil
    @State private var prevSpotId: ObjectIdentifier? = nil
    @State private var prevSpotDepth: Int = 0
    @State private var pathText: String = ""
    @State private var stickyLeafVm: LeafVm? = nil
    @State private var leafExpanded: Bool = false
    @State private var liveValueText: String? = nil
    @State private var dragStartTime: Date? = nil
    @State private var sawLeafSpot: Bool = false

    var body: some View {
        // WWDC22 "Build a productivity app for Apple Watch" pattern:
        // - mainContent respects the safe area so menus + corner logos sit
        //   inside the rounded display, never clipped.
        // - Title overlay ignores safe area on the TOP only, so the title
        //   sits on the same row as the system clock.
        NavigationStack {
            mainContent
                .overlay(alignment: .topLeading) {
                    Text(topLabel)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)
                        .truncationMode(.head)
                        .minimumScaleFactor(0.5)
                        .padding(.leading, 8)
                        .padding(.top, 4)
                        .ignoresSafeArea(.container, edges: .top)
                        .allowsHitTesting(false)
                }
                .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var mainContent: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                vm.menuView
                if leafExpanded, let leaf = stickyLeafVm {
                    let closeEdit: () -> Void = {
                        leafExpanded = false
                        liveValueText = nil
                        // Force the tiny menu-mode view to redraw with the new
                        // thumb position now that edit-mode has updated the value.
                        leaf.refreshView()
                    }
                    if let valVm = leaf as? LeafValVm {
                        WatchLeafYController(
                            leafVm: valVm,
                            onExit: closeEdit,
                            onValueLive: { text in liveValueText = text }
                        )
                    } else {
                        WatchLeafController(
                            leafVm: leaf,
                            onExit: closeEdit,
                            onValueLive: { text in liveValueText = text }
                        )
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        if leafExpanded { return }

                        if activeCornerVm == nil {
                            let chosen = closestCorner(to: value.startLocation)
                            // Exclusivity: collapse any other corner's tree that
                            // might still be visible from a recent interaction.
                            for cv in vm.cornerVms where cv !== chosen {
                                cv.rootVm?.treeVms.forEach { $0.showTree.hideNow() }
                            }
                            activeCornerVm = chosen
                            dragStartTime = Date()
                            sawLeafSpot = false
                        }
                        if let cv = activeCornerVm {
                            cv.updateDragXY(value.location)
                            updateSpot(cv)
                        }
                    }
                    .onEnded { _ in
                        // Lift-tap detection: drag finished within 250ms of
                        // beginning AND there's a sticky XY/XYZ leaf. Works
                        // from anywhere — no need to end touch on the leaf.
                        if !leafExpanded,
                           let start = dragStartTime,
                           Date().timeIntervalSince(start) < 0.25,
                           stickyLeafVm != nil {
                            leafExpanded = true
                        }
                        activeCornerVm?.updateDragXY(.zero)
                        activeCornerVm = nil
                        prevSpotId = nil
                        prevSpotDepth = 0
                        dragStartTime = nil
                        sawLeafSpot = false
                    }
            )
        }
    }

    private var topLabel: String {
        if let live = liveValueText { return live }
        if leafExpanded, let leaf = stickyLeafVm {
            return "» " + leaf.menuTree.flo.name
        }
        return pathText
    }

    private var oppositeCornerForLeaf: MenuCorner? {
        guard let leaf = stickyLeafVm else { return nil }
        switch leaf.rootVm.cornerVm.menuType.corner {
        case .SW: return .NE
        case .SE: return .NW
        case .NW: return .SE
        case .NE: return .SW
        case .none: return nil
        }
    }

    private func isInCornerZone(_ point: CGPoint, corner: MenuCorner, bounds: CGRect) -> Bool {
        let zoneFraction: CGFloat = 0.4
        let w = bounds.width, h = bounds.height
        let inLeft = point.x < bounds.minX + w * zoneFraction
        let inRight = point.x > bounds.maxX - w * zoneFraction
        let inTop = point.y < bounds.minY + h * zoneFraction
        let inBottom = point.y > bounds.maxY - h * zoneFraction
        switch corner {
        case .NW: return inLeft && inTop
        case .NE: return inRight && inTop
        case .SW: return inLeft && inBottom
        case .SE: return inRight && inBottom
        case .none: return false
        }
    }

    private func updateSpot(_ cv: CornerVm) {
        guard let rootVm = cv.rootVm,
              let spot = rootVm.nodeSpotVm else { return }
        let currId = ObjectIdentifier(spot)
        guard currId != prevSpotId else { return }

        let currDepth = spot.menuTree.wordPath.count
        let prevDepth = prevSpotDepth

        if prevSpotId == nil {
            feedback.value.sibling(index: 0, count: 1)
        } else if currDepth > prevDepth {
            feedback.value.child(depth: currDepth)
        } else if currDepth < prevDepth {
            feedback.value.parent(depth: currDepth)
        } else {
            let siblings = spot.menuTree.parentTree?.children ?? []
            let idx = siblings.firstIndex(where: { $0 === spot.menuTree }) ?? 0
            feedback.value.sibling(index: idx, count: max(1, siblings.count))
        }

        if let xy = spot as? LeafXyVm {
            stickyLeafVm = xy
            sawLeafSpot = true
        } else if let xyz = spot as? LeafXyzVm {
            stickyLeafVm = xyz
            sawLeafSpot = true
        } else if let val = spot as? LeafValVm {
            stickyLeafVm = val
            sawLeafSpot = true
        }

        prevSpotId = currId
        prevSpotDepth = currDepth
        pathText = "» " + spot.menuTree.flo.name
    }

    private func closestCorner(to point: CGPoint) -> CornerVm? {
        let corners = vm.cornerVms
        guard !corners.isEmpty else { return nil }
        return corners.min { a, b in
            distance(a.parkIconXY, point) < distance(b.parkIconXY, point)
        }
    }

    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x, dy = a.y - b.y
        return (dx * dx + dy * dy).squareRoot()
    }
}
