//  Created by warren on 12/19/22.

import MuMenu
import Foundation

extension TouchView: PeersControllerDelegate {

    public func didChange() {
    }

    public func received(data: Data,
                         viaStream: Bool) {

        let decoder = JSONDecoder()
        if let item = try? decoder.decode(MenuItem.self, from: data) {
            TouchMenu.remoteItem(item)
            return
        }
    }

}
