import SwiftUI

/// four posible corners
struct MuRootView: View {
    @EnvironmentObject var root: MuRoot
    var body: some View {
        switch root.corner {
            case [.lower, .right]: LowerRightView()
            case [.lower, .left ]: LowerLeftView()
            case [.upper, .right]: UpperRightView()
            case [.upper, .left ]: UpperLeftView()
            default:               LowerRightView()
        }
    }
}

/// space with: vert, hori, and pilot views
private struct SpaceView: View {
    @EnvironmentObject var root: MuRoot
    var body: some View {

        ForEach(root.limbs, id: \.id) {
            MuLimbView(limb: $0)
        }
        MuPilotView(pilot: root.pilot)
    }
}

/// lower right corner of space
private struct LowerRightView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            ZStack(alignment: .bottomTrailing) {
                SpaceView()
            }
        }
    }
}

/// upper right corner of space
private struct UpperRightView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .top) {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    SpaceView()
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

/// lower left corner of space
private struct LowerLeftView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            ZStack(alignment: .bottomLeading) {
                SpaceView()
            }
            Spacer()
        }
    }
}

/// upper left corner of space
private struct UpperLeftView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    SpaceView()
                }
                Spacer()
            }
            Spacer()
        }
    }
}
