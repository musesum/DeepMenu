// Created by warren on 10/7/21.

import SwiftUI

struct MuDockRectView: View {
    var border: MuBorder
    var body: some View {
        GeometryReader { geo in
            let size = geo.frame(in: .named("Space")).size
            Rectangle()
                // .fill(Color.gray)
                .opacity(0.1)

//                .fill(Color(white: 0.2, opacity: 0.5))
//                //.blur(radius: -5)
                .background(.ultraThinMaterial)
//                .opacity(0.1)
                .frame(width: size.width, height: size.height)
                .cornerRadius(border.cornerRadius)
        }

    }
}
