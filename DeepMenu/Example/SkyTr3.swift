import UIKit
import Tr3
import Par

class SkyTr3: NSObject {
    
    static let shared = SkyTr3()
    public let root = Tr3("√")

    override init() {
        
        super.init()

        parseScriptFiles()
    }

    func parseScriptFiles() {
        func parseFile(_ fileName: String) {
            let _ = Tr3Parse.shared.parseTr3(root, fileName)
        }

        parseFile("sky.main")
        parseFile("sky.shader")
        parseFile("sky.menu")
        parseFile("midi")

        let script = root.makeTr3Script(indent: 0, pretty: false)
        print(script)
    }
}
