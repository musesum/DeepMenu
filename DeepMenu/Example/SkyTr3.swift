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
        parseFile("sky.midi")
        parseFile("sky.shader")
        parseFile("panel.cell")
        parseFile("panel.camera")
        parseFile("panel.cell.fader")
        parseFile("panel.cell.average")
        parseFile("panel.cell.melt")
        parseFile("panel.cell.timeTunnel")
        parseFile("panel.cell.zhabatinski")
        parseFile("panel.cell.slide")
        parseFile("panel.cell.fredkin")

        parseFile("panel.cell.brush")
        parseFile("panel.shader.colorize")
        parseFile("panel.cell.scroll")
        parseFile("panel.shader.tile")
        parseFile("panel.cell.camera")
        parseFile("panel.record")
        parseFile("panel.cell.speed")

        let script = root.makeScript(indent: 0, pretty: false)
        print(script)
    }
}
