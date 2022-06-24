menu {
    canvas (icon "icon.drop.clear") {
        fill (icon "icon.speed.png") {
            plane (val 0)
            zero  (tap, icon "icon.drop.clear") >> sky.draw.fill(0)
            one   (tap, icon "icon.drop.gray")  >> sky.draw.fill(-1)
        }
        tile (icon "icon.shader.tile.png") {
            mirror (vxy, x -1…1, y -1…1, icon "icon.shader.tile.png") >> shader.pipe.mirror

            repeat (vxy, x -1…1, y -1…1, icon "icon.shader.tile.png") >> shader.pipe.repeat
        }
        scroll (icon "icon.cell.scroll.png") {
            shift (vxy, x 0.5, y 0.5, icon "icon.cell.scroll.png") >> shader.pipe.scroll
            tilt  (tog 0, icon "icon.pen.tilt.png") // brushTilt
        }
        color(icon "icon.pal.main.png") {
            fade  (vxy, x 0, y 0, icon "icon.scroll.png")
            plane (val, icon "icon.pen.tilt.png")
        }
    }
    speed (icon "icon.speed.png") {
        fps (seg 0…60=60, icon "icon.speed.png"  ) >> sky.main.fps
        run (tog 1,       icon "icon.thumb.x.png") >> sky.main.run
    }
    brush (icon "icon.cell.brush.png") {
        size  (val 0.5, icon "icon.pen.press.png") >> sky.draw.brush.size
        press (tog 1  , icon "icon.pen.press.png") >> sky.draw.brush.press
        tilt  (tog 1  , icon "icon.pen.tilt.png") >> sky.input.brush.tilt
    }
    cell {
        fade  (val 2…3=2.2, icon "icon.cell.fade" ) >> shader.cell.fade
        ave   (val 0.5    , icon "icon.cell.ave"  ) >> shader.cell.ave
        melt  (val 0.5    , icon "icon.cell.melt" ) >> shader.cell.melt
        tunl  (seg 0…5=1  , icon "icon.cell.time" ) >> shader.cell.tunl
        zha   (seg 0…6=2  , icon "icon.cell.zha"  ) >> shader.cell.zha
        slide (seg 0…7=3  , icon "icon.cell.slide") >> shader.cell.slide
        fred  (seg 0…4=4  , icon "icon.cell.fred" ) >> shader.cell.fred
    }
    cam (icon "icon.camera.png") {
        snap  (tap  0, icon "icon.camera.png")
        fake  (tog  0, icon "icon.camera.png")
        real  (tog  1, icon "icon.camera.png")
        face  (tog  1, icon "icon.camera.flip.png") >> shader.pipe.camera.flip
        xfade (val .5, icon "icon.pearl.white.png")
    }
}
