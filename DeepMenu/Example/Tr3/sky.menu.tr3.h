menu {
    canvas (icon "icon.drop.clear") {
        fill (icon "icon.speed.png") {
            plane (dial, v 0)
            zero  (pad, x 0, y 0, icon "icon.drop.clear") // fillZero
            one   (pad, x 0, y 0, icon "icon.drop.gray") // fillOne
        }
        tile (icon "icon.shader.tile.png") {
            mirror (box, x 0, y 0, icon "icon.shader.tile.png") // mirrorBox
            repeat (box, x 0, y 0, icon "icon.shader.tile.png") // repeatBox
        }
        scroll (icon "icon.cell.scroll.png") {
            box  (box, x 0.5, y 0.3, icon "icon.cell.scroll.png") // scrollBox
            tilt (tog, v 0.25, icon "icon.pen.tilt.png") // brushTilt
        }
        color(icon "icon.pal.main.png") {
            fade (box, x 0, y 0, icon "icon.scroll.png") // scrollBox
            tilt (tog, x 0, y 0, icon "icon.pen.tilt.png") // brushTilt
        }
    }
    speed (icon "icon.speed.png") {
        fps   (dial, v 0..1=0.5, icon "icon.speed.png")
        pause (tog, icon "icon.thumb.x.png")
    }
    brush (icon "icon.cell.brush.png") {
        size  (dial, v 0..1=0.5,icon "icon.pen.press.png") // brushSize
        press (tog, icon "icon.pen.press.png") // brushPress
        tilt  (tog, icon "icon.pen.tilt.png") // brushPress
    }
    cell {
        fade  (dial, v 0..1=0.5,icon "icon.cell.fader")            >> sky.shader.fade.version
        ave   (dial, v 0..1=0.5,icon "icon.cell.average")          >> sky.shader.ave.version
        melt  (dial, v 0..1=0.5,icon "icon.cell.melt")             >> sky.shader.melt.version
        tunl  (seg, v 0..5=1, icon "icon.cell.time")        >> sky.shader.tunl.version
        zha   (seg, v 0..6=2, icon "icon.cell.zhabatinski") >> sky.shader.zha.version
        slide (seg, v 0..7=3, icon "icon.cell.slide.png")   >> sky.shader.slide.version
        fred  (seg, v 0..4=4, icon "icon.cell.fredkin.png") >> sky.shader.fred.version
    }
    camera (icon "icon.camera.png") {
        fake (tog, v 1, icon "icon.camera.png")
        real (tog, v 1, icon "icon.camera.png")
        face (tog, v 1, icon "icon.camera.flip.png") >> sky.shader.camera.flip
        xfade(dial, v .5,icon "icon.pearl.white.png")
        snap (pad, v 0, icon "icon.camera.png")
    }
}
