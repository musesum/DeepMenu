// Created by warren on 10/7/21.


import SwiftUI

struct MuPanelAxisView<Content: View>: View {

    let panelVm: MuPanelVm
    let content: () -> Content

    init(_ panel: MuPanelVm, @ViewBuilder content: @escaping () -> Content) {
        self.panelVm = panel
        self.content = content
    }

    var body: some View {

        // even though .vxy has only one inner view, a
        // .horizonal ScrollView shifts and truncates the inner views
        // so, perhaps there is a phantom space for indicators?
        
        if panelVm.axis == .vertical  || panelVm.type == .vxy {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading,
                       spacing: panelVm.spacing,
                       content: content)
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom,
                       spacing: panelVm.spacing,
                       content: content)
            }
        }
    }
}
