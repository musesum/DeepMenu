//
//  ExampleClient.swift
//  DeepMenu
//
//  Created by warren on 4/13/22.
//

import SwiftUI

class ExampleClientModel: ObservableObject {

    @Published var path: String = "."
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0
}

struct ExampleClientView: View {
    @ObservedObject var model = ExampleClientModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("path: \(model.path)")
            Text("x: \(model.x)")
            Text("y: \(model.y)")
        }
    }
}
