// Created by warren 10/29/21.
import SwiftUI

/// hierarchical menu of horizontal or vertical branches
struct MuLimbView: View {

    @EnvironmentObject var rootVm: MuRootVm
    @ObservedObject var limbVm: MuLimbVm
    
    var body: some View {
        
        if limbVm.axis == .horizontal {
            VStack(alignment: rootVm.corner.contains(.left) ? .leading : .trailing) {
                ForEach(rootVm.corner.contains(.lower) ? limbVm.branches.reversed() : limbVm.branches, id: \.id) {
                    MuBranchView(branch: $0)
                        .zIndex($0.level)
                }
            }
            .offset(limbVm.offset)
        } else {
            HStack(alignment: rootVm.corner.contains(.upper) ? .top : .bottom) {
                ForEach(rootVm.corner.contains(.right) ? limbVm.branches.reversed() : limbVm.branches, id: \.id) {
                    MuBranchView(branch: $0)
                        .zIndex($0.level)
                }
            }
            .offset(limbVm.offset)
        }
    }
}
