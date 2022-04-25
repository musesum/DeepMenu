// Created by warren 10/29/21.
import SwiftUI

/// hierarchical menu of horizontal or vertical  branches
struct MuLimbView: View {

    @EnvironmentObject var root: MuRoot
    @ObservedObject var limb: MuLimb
    
    var body: some View {
        
        if limb.axis == .horizontal {
            VStack(alignment: root.corner.contains(.left) ? .leading : .trailing) {
                ForEach(root.corner.contains(.lower) ? limb.branches.reversed() : limb.branches, id: \.id) {
                    MuBranchView(branch: $0)
                        .zIndex($0.level)
                }
            }
            .offset(limb.offset)
        } else {
            HStack(alignment: root.corner.contains(.upper) ? .top : .bottom) {
                ForEach(root.corner.contains(.right) ? limb.branches.reversed() : limb.branches, id: \.id) {
                    MuBranchView(branch: $0)
                        .zIndex($0.level)
                }
            }
            .offset(limb.offset)
        }
    }
}
