// Created by warren 10/29/21.
import SwiftUI

/// hierarchical menu of horizontal or vertical branches
struct MuTreeView: View {

    @EnvironmentObject var rootVm: MuRootVm
    @ObservedObject var treeVm: MuTreeVm
    
    var body: some View {
        
        if treeVm.axis == .horizontal {
            VStack(alignment: rootVm.corner.contains(.left) ? .leading : .trailing) {
                ForEach(rootVm.corner.contains(.lower)
                        ? treeVm.branchVms.reversed()
                        : treeVm.branchVms, id: \.id) {
                    MuBranchView(branchVm: $0,
                                 spotlight: $0 == treeVm.branchSpot)
                        .zIndex($0.level)
                }
            }
            .offset(treeVm.offset)
        } else {
            HStack(alignment: rootVm.corner.contains(.upper) ? .top : .bottom) {
                ForEach(rootVm.corner.contains(.right)
                        ? treeVm.branchVms.reversed()
                        : treeVm.branchVms, id: \.id) {
                    MuBranchView(branchVm: $0,
                                 spotlight: $0 == treeVm.branchSpot)
                        .zIndex($0.level)
                }
            }
            .offset(treeVm.offset)
        }
    }
}
