menu {
    canvas (icon "icon.drop.clear") {
        fill (icon "icon.speed.png") {
            plane (slide)
            zero  (drum, icon "icon.drop.clear") // fillZero
            one   (drum, icon "icon.drop.gray") // fillOne
        }
        tile (icon "icon.shader.tile.png") {
            mirror (boxy, icon "icon.shader.tile.png") // mirrorBox
            repeat (boxy, icon "icon.shader.tile.png") // repeatBox
        }
        scroll (icon "icon.cell.scroll.png") {
            box  (boxy, icon "icon.cell.scroll.png") // scrollBox
            tilt (togl, icon "icon.pen.tilt.png") // brushTilt
        }
        color(icon "icon.pal.main.png") {
            fade (boxy, icon "icon.scroll.png") // scrollBox
            tilt (togl, icon "icon.pen.tilt.png") // brushTilt
        }
    }
    speed (icon "icon.speed.png") {
        fps   (slide, icon "icon.speed.png")
        pause (togl, icon "icon.thumb.x.png")
    }
    brush (icon "icon.cell.brush.png") {
        size  (slide, icon "icon.pen.press.png") // brushSize
        press (togl, icon "icon.pen.press.png") // brushPress
        tilt  (togl, icon "icon.pen.tilt.png") // brushPress
    }
    cell {
        fade  (slide, icon "icon.cell.fader")            >> sky.shader.fade.version
        ave   (slide, icon "icon.cell.average")          >> sky.shader.ave.version
        melt  (slide, icon "icon.cell.melt")             >> sky.shader.melt.version
        tunl  (segmt 0..5, icon "icon.cell.time")        >> sky.shader.tunl.version
        zha   (segmt 0..6, icon "icon.cell.zhabatinski") >> sky.shader.zha.version
        slide (segmt 0..7, icon "icon.cell.slide.png")   >> sky.shader.slide.version
        fred  (segmt 0..4, icon "icon.cell.fredkin.png") >> sky.shader.fred.version
    }
    camera (icon "icon.camera.png") {
        fake (togl, icon "icon.camera.png")
        real (togl, icon "icon.camera.png")
        face (togl, icon "icon.camera.flip.png") >> sky.shader.camera.flip
        xfade(slide, icon "icon.pearl.white.png")
        snap (drum,  icon "icon.camera.png")
    }
}
