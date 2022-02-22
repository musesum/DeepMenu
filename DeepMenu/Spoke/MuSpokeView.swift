// Created by warren 10/29/21.
import SwiftUI

/// hierarchical menu of horizontal or vertical  docks
struct MuSpokeView: View {

    @EnvironmentObject var hub: MuHub
    @ObservedObject var spoke: MuSpoke
    
    var body: some View {
        
        if spoke.axis == .horizontal {
            VStack(alignment: hub.corner.contains(.left) ? .leading : .trailing) {
                ForEach(hub.corner.contains(.lower) ? spoke.docks.reversed() : spoke.docks, id: \.id) {
                    MuDockView(dock: $0)
                        .zIndex($0.level)
                }
            }
            .offset(spoke.offset)
        } else {
            HStack(alignment: hub.corner.contains(.upper) ? .top : .bottom) {
                ForEach(hub.corner.contains(.right) ? spoke.docks.reversed() : spoke.docks, id: \.id) {
                    MuDockView(dock: $0)
                        .zIndex($0.level)
                }
            }
            .offset(spoke.offset)
        }
    }
}
