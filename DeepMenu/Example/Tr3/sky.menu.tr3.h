menu {
    canvas (icon "icon.drop.clear") {
        fill (icon "icon.speed.png") {
            plane (sldr, v 0)
            zero  (tap, x 0, y 0, icon "icon.drop.clear") // fillZero
            one   (tap, x 0, y 0, icon "icon.drop.gray") // fillOne
        }
        tile (icon "icon.shader.tile.png") {
            mirror (boxy, x 0, y 0, icon "icon.shader.tile.png") // mirrorBox
            repeat (boxy, x 0, y 0, icon "icon.shader.tile.png") // repeatBox
        }
        scroll (icon "icon.cell.scroll.png") {
            shift (boxy, x 0.5, y 0.3, icon "icon.cell.scroll.png") // scrollBox
            tilt  (togl, v 0.25, icon "icon.pen.tilt.png") // brushTilt
        }
        color(icon "icon.pal.main.png") {
            fade (boxy, x 0, y 0, icon "icon.scroll.png") // scrollBox
            tilt (togl, x 0, y 0, icon "icon.pen.tilt.png") // brushTilt
        }
    }
    speed (icon "icon.speed.png") {
        fps   (sldr, v 0..1=0.5, icon "icon.speed.png")
        pause (togl, icon "icon.thumb.x.png")
    }
    brush (icon "icon.cell.brush.png") {
        size  (sldr, v 0..1=0.5,icon "icon.pen.press.png") // brushSize
        press (togl, icon "icon.pen.press.png") // brushPress
        tilt  (togl, icon "icon.pen.tilt.png") // brushPress
    }
    cell {
        fade  (sldr, v 0..1=0.5, icon "icon.cell.fade")  >> shader.fade.version
        ave   (sldr, v 0..1=0.5, icon "icon.cell.ave")   >> shader.ave.version
        melt  (sldr, v 0..1=0.5, icon "icon.cell.melt")  >> shader.melt.version
        tunl  (sgmt, v 0..5=1,   icon "icon.cell.time")  >> shader.tunl.version
        zha   (sgmt, v 0..6=2,   icon "icon.cell.zha")   >> shader.zha.version
        slide (sgmt, v 0..7=3,   icon "icon.cell.slide") >> shader.slide.version
        fred  (sgmt, v 0..4=4,   icon "icon.cell.fred")  >> shader.fred.version
    }
    camera (icon "icon.camera.png") {
        fake (togl, v 1, icon "icon.camera.png")
        real (togl, v 1, icon "icon.camera.png")
        face (togl, v 1, icon "icon.camera.flip.png") >> sky.shader.camera.flip
        snap (tap,  v 0, icon "icon.camera.png")
        xfade(sldr, v .5,icon "icon.pearl.white.png")
    }
}
