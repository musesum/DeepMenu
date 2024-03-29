
import QuartzCore
import UIKit
import MuFlo
import MuPar // Visitor

class TouchDraw {

    static let shared = TouchDraw()

    private let brushTilt˚  : Flo
    private let brushPress˚ : Flo
    private let brushSize˚  : Flo
    private let brushIndex˚ : Flo

    private let linePrev˚   : Flo // beginning of line
    private let lineNext˚   : Flo // end of line
    private let inForce˚    : Flo // pressure
    private let inRadius˚   : Flo // finger radius
    private let inAzimuth˚  : Flo // apple pencil angle
    private let screenFill˚ : Flo
    private let drawDotOn˚  : Flo
    private let drawDotOff˚ : Flo

    private var brushTilt = false          // via brushTilt˚
    private var brushPress = true          // via brushPress˚
    private var brushSize = CGFloat(1)     // via brushSize˚
    private var brushIndex = UInt32(127)   // via brushIndex˚

    private var linePrev = CGPoint.zero    // via linePrev˚
    private var lineNext = CGPoint.zero    // via lineNext˚
    private var inForce = CGFloat(0)       // via inForce˚
    private var inRadius = CGFloat(0)      // via inRadius˚
    private var inAzimuth = CGPoint.zero   // var inAzimuth˚
    private var fillValue = Float(-1)

    private var texBuf: UnsafeMutablePointer<UInt32>?
    private var texSize = CGSize.zero

    init() {
        let root = SkyFlo.shared.root
        let sky     = root  .bindPath("sky"    )
        let input   = sky   .bindPath("input"  )
        let draw    = sky   .bindPath("draw"   )
        let brush   = draw  .bindPath("brush"  )
        let line    = draw  .bindPath("line"   )
        let screen  = draw  .bindPath("screen" )

        brushTilt˚  = input .bindPath("tilt"   )
        brushPress˚ = brush .bindPath("press"  )
        brushSize˚  = brush .bindPath("size"   )
        brushIndex˚ = brush .bindPath("index"  )

        linePrev˚   = line  .bindPath("prev"   )
        lineNext˚   = line  .bindPath("next"   )
        inForce˚    = input .bindPath("force"  )
        inRadius˚   = input .bindPath("radius" )
        inAzimuth˚  = input .bindPath("azimuth")
        screenFill˚ = screen.bindPath("fill"   )
        drawDotOn˚  = draw  .bindPath("dot.on" )
        drawDotOff˚ = draw  .bindPath("dot.off")

        setupClosures()
    }
    func setupClosures() {
        brushTilt˚ .addClosure { t,_ in self.brushTilt  = t.BoolVal() }
        brushPress˚.addClosure { t,_ in self.brushPress = t.BoolVal() }
        brushSize˚ .addClosure { t,_ in self.brushSize  = t.CGFloatVal() ?? 1 }
        brushIndex˚.addClosure { t,_ in self.brushIndex = UInt32(t.CGFloatVal() ?? 127) }

        linePrev˚  .addClosure { t,_ in self.linePrev   = t.CGPointVal() ?? .zero }
        lineNext˚  .addClosure { t,_ in self.lineNext   = t.CGPointVal() ?? .zero }
        inForce˚   .addClosure { t,_ in self.inForce    = t.CGFloatVal() ?? 1 }
        inRadius˚  .addClosure { t,_ in self.inRadius   = t.CGFloatVal() ?? 1 }
        inAzimuth˚ .addClosure { t,_ in self.inAzimuth  = t.CGPointVal() ?? .zero }
        screenFill˚.addClosure { t,_ in self.fillValue  = t.FloatVal() ?? -1 }

        // midi.notes.dot >> sky.draw.dot
        drawDotOn˚.addClosure { t, _ in addCanvasItem(t.val, phase: .began) }
        drawDotOn˚.addClosure { t, _ in addCanvasItem(t.val, phase: .ended) }

        func addCanvasItem(_ val: FloVal?, phase: UITouch.Phase) {
            if let exprs = val as? FloValExprs,
               let x = exprs.nameAny["x"] as? FloValScalar,
               let y = exprs.nameAny["y"] as? FloValScalar,
               let z = exprs.nameAny["z"] as? FloValScalar {

                let margin = CGFloat(48)
                let xs = CGFloat(2388/2) //??
                let ys = CGFloat(1668/2) //??
                let xx = CGFloat(x.now) / 12
                let yy = 1 - CGFloat(y.now / 12)
                let xxx = CGFloat(xx * xs) + margin
                let yyy = CGFloat(yy * ys) - margin
                let point = CGPoint(x: xxx, y: yyy)
                let radius = Float(z.now/2 + 1)
                
                let key = "drawDot".hash
                let item = TouchCanvasItem(key, point, radius, radius, .zero, phase, Visitor(.midi))
                TouchCanvas.addCanvasItem(item, isRemote: false)
            }
        }
    }

    public func update(_ item: TouchCanvasItem,
                       _ visit: Visitor) -> CGFloat { 

        // if using Apple Pencil and brush tilt is turned on
        if item.force > 0, brushTilt {
            let azi = CGPoint(x: CGFloat(-item.azimY), y: CGFloat(-item.azimX))
            inAzimuth˚.setAny(azi, [.activate], visit)
          //PrintGesture("azimuth dXY(%.2f,%.2f)", item.azimuth.dx, item.azimuth.dy)
        }
        
        // if brush press is turned on
        var radiusNow = CGFloat(1)
        if brushPress  {
            if inForce > 0 || item.azimX != 0.0 {
                inForce˚.setAny(item.force, [.activate], visit) // will update local azimuth via FloGraph
                radiusNow = brushSize
            } else {
                inRadius˚.setAny(item.radius, [.activate], visit)
                radiusNow = inRadius
            }
        } else {
            radiusNow = brushSize
        }
        return radiusNow
    }

    /**
     Either fill or draw inside texture
     - returns: true if filled, false if drawn
     */

    func drawTexture(_ texBuf: UnsafeMutablePointer<UInt32>,
                     size: CGSize) -> Bool {

        self.texBuf = texBuf
        self.texSize = size

        if TextureData.shared.data != nil {
            fillValue = -1 // preempt fill after data
            drawData()
            return false
        } else if fillValue > 255 {
            let fill = UInt32(fillValue)
            drawFill(fill)
            fillValue = -1
            return false
        } else if fillValue >= 0 {
            let v8 = UInt32(fillValue * 255)
            let fill = (v8 << 24) + (v8 << 16) + (v8 << 8) + v8
            drawFill(fill)
            fillValue = -1
            return false
        } else {
            TouchCanvas.flushTouchCanvas()
            return false // didn't fill so don't duplicate 2nd texture
        }
    }
    func drawPoint(_ point: CGPoint,
                   _ radius: CGFloat) {

        guard let texBuf else { return }
        if point == .zero { return }
        let p = point * UIScreen.main.scale
        let viewSize = SkyPipeline.shared.viewSize
        let p1 = MuAspect.viewPointToTexture(p, viewSize: viewSize, texSize: texSize)

        let r = radius * 2.0 - 1
        let r2 = Int(r * r / 4.0)
        let xs = Int(texSize.width)
        let ys = Int(texSize.height)
        let px = Int(p1.x)
        let py = Int(p1.y)

        var x0 = Int(p1.x - radius - 0.5)
        var y0 = Int(p1.y - radius - 0.5)
        var x1 = Int(p1.x + radius + 0.5)
        var y1 = Int(p1.y + radius + 0.5)

        if x0 < 0 { x0 += xs }
        if y0 < 0 { y0 += ys }
        while x1 < x0 { x1 += xs }
        while y1 < y0 { y1 += ys }

        if radius == 1 {
            texBuf[y0 * xs + x0] = brushIndex
            return
        }

        for y in y0 ..< y1 {

            for x in x0 ..< x1  {

                let xd = (x - px) * (x - px)
                let yd = (y - py) * (y - py)

                if xd + yd < r2 {

                    let yy = (y + ys) % ys  // wrapped pixel y index
                    let xx = (x + xs) % xs  // wrapped pixel x index
                    let ii = yy * xs + xx   // final pixel x, y index into buffer

                    texBuf[ii] = brushIndex     // set the buffer to value
                }
            }
        }
    }
    func drawFill(_ fill: UInt32) {
        guard let texBuf else { return }
        
        let w = Int(texSize.width)
        let h = Int(texSize.height)
        let count = w * h // count

        for i in 0 ..< count {
            texBuf[i] = fill
        }
    }
    func drawData() {

        let w = Int(texSize.width)
        let h = Int(texSize.height)
        let count = w * h // count

        TextureData.shared.data?.withUnsafeBytes { dataPtr in
            guard let texBuf else { return }
            let tex32Ptr = dataPtr.bindMemory(to: UInt32.self)
            for i in 0 ..< count {
                texBuf[i] = tex32Ptr[i]
            }
        }
        TextureData.shared.data = nil
    }
}
