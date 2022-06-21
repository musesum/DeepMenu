//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {
        MuLeafView(leafVm) {
            //TODO: Add grey/white flash here
        }
    }
}
