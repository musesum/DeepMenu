menu {
    canvas (title "canvas", type "node", icon "icon.drop.clear") {
        fill (title "fill", type "node", icon "icon.speed.png") {
            plane (title "Bit Plane", type "slider", value 0..1)
            zero  (title "Fill Zero", type "pad"   , value 0..1, icon "icon.drop.clear") // fillZero
            one   (title "Fill Ones", type "pad"   , value 0..1, icon "icon.drop.gray") // fillOne
        }
        tile (title "tile", type "node", icon "icon.shader.tile.png") {
            mirror (title "Mirror", type "rectXY", x 0..1, y 0..1, icon "icon.pearl.white.png") // mirrorBox
            repeat (title "Repeat", type "rectXY", x 0..1, y 0..1, icon "icon.pearl.white.png") // repeatBox
        }
        scroll (title "scroll", type "node", icon "icon.cell.scroll.png") {
            box  (title "Screen Scroll", type "rectXY", x 0..1, y 0..1, icon "icon.cell.scroll.png") // scrollBox
            tilt (title "Brush Tilt"   , type "toggle", value 0..1, icon "icon.pen.tilt.png") // brushTilt
        }
        color(title "color", type "node", icon "icon.pal.main.png") {
            fade (title "Screen Scroll", type "rectXY", x 0..1, y 0..1 , icon "icon.scroll.png") // scrollBox
            tilt (title "Brush Tilt"   , type "toggle", value 0..1, icon "icon.pen.tilt.png") // brushTilt
        }
    }
    speed (title "speed", type "node", icon "icon.speed.png") {
        fps   (title "fps"  , type "slider", value 0..1, icon "icon.speed.png")
        pause (title "pause", type "toggle", value 0..1, icon "icon.thumb.x.png")
    }
    brush (title "brush", type "node", icon "icon.cell.brush.png") {
        size  (title "brush size", type "slider", value 0..1, icon "icon.pen.press.png") // brushSize
        press (title "pen press" , type "toggle", value 0..1, icon "icon.pen.press.png") // brushPress
        tilt  (title "pen title", type "toggle", value 0..1, icon "icon.pen.tilt.png") // brushPress
    }
    cell (title "cell", type "node") {
        fade  (title "fade away"   , type "slider" , value 0..1, icon "icon.cell.fader")
        ave   (title "average"     , type "slider" , value 0..1, icon "icon.cell.average")
        melt  (title "reaction"    , type "slider" , value 0..1, icon "icon.cell.melt")
        tunl  (title "time tunnel" , type "segment", value 0..5, icon "icon.cell.time")
        zha   (title "zhabatinski" , type "segment", value 0..6, icon "icon.cell.zhabatinski")
        slide (title "slide planes", type "segment", value 0..7, icon "icon.cell.slide.png")
        fred  (title "fredkin"     , type "segment", value 0..4, icon "icon.cell.fredkin.png")
    }
    camera (title "camera", type "node", icon "icon.camera.png") {
        fake (title "false color", type "toggle", value 0..1, icon "icon.camera.png")
        real (title "real color" , type "toggle", value 0..1, icon "icon.camera.png")
        face (title "facing"     , type "toggle", value 0..1, icon "icon.camera.flip.png") >> sky.shader.cellCamera.flip
        xfade(title "cross fade" , type "slider", value 0..1, icon "icon.pearl.white.png")
        snap (title "snapshot"   , type "pad"   , value 0..1, icon "icon.camera.png")
    }
}
