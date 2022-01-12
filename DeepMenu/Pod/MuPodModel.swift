// Created by warren on 10/17/21.

import SwiftUI

/// shared between 1 or more MuPod, stored
class MuPodModel: Identifiable {
    let id = MuIdentity.getId() //TODO: use a persistent storage ID after debugging
    
    var name: String // pilot's name may be changed hubd on corner placement
    let title: String
    let type: MuBorderType
    var subModels: [MuPodModel]?
    var subNow:  MuPodModel? // most recently selected, persist to storage

    init(_ name: String,
         suprModel: MuPodModel? = nil,
         subModels: [MuPodModel]? = nil) {

        self.name = name
        self.type = .pod
        self.title = (suprModel?.title ?? "") + name
        self.subModels = subModels
    }
}
