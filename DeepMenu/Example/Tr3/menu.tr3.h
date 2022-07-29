menu {
    canvas {
        fill (image "icon.speed") {
            plane (val 0)
            zero  (tap, image "icon.drop.clear") >> sky.draw.fill(0)
            one   (tap, image "icon.drop.gray")  >> sky.draw.fill(-1)
        }
        tile (image "icon.shader.tile.png") {
            mirror (vxy, x -1…1, y -1…1) >> shader.pipe.mirror
            repeat (vxy, x -1…1, y -1…1) >> shader.pipe.repeat
        }
        scroll (image "icon.cell.scroll.png") {
            shift (vxy, x 0.5, y 0.5, image "icon.cell.scroll") >> shader.pipe.scroll
            tilt  (tog 0, image "icon.pen.tilt") // brushTilt
        }
        color(image "icon.pal.main") {
            fade  (vxy, x 0, y 0, image "icon.scroll")
            plane (val, image "icon.pen.tilt")
        }
    }
    speed (image "icon.speed") {
        fps (seg 0…60=60) >> sky.main.fps
        run (tog 1      ) >> sky.main.run
    }
    brush (symbol "square.and.pencil") {
        size  (val 0.5) >> sky.draw.brush.size
        press (tog 1  , image "icon.pen.press") >> sky.draw.brush.press
        tilt  (tog 1  , image "icon.pen.tilt") >> sky.input.brush.tilt
    }
    cell {
        fade  (val 2…3=2.2, image "icon.cell.fade" ) >> shader.cell.fade
        ave   (val 0.5    , image "icon.cell.ave"  ) >> shader.cell.ave
        melt  (val 0.5    , image "icon.cell.melt" ) >> shader.cell.melt
        tunl  (seg 0…5=1  , image "icon.cell.tunl" ) >> shader.cell.tunl
        zha   (seg 0…6=2  , image "icon.cell.zha"  ) >> shader.cell.zha
        slide (seg 0…7=3  , image "icon.cell.slide") >> shader.cell.slide
        fred  (seg 0…4=4  , image "icon.cell.fred" ) >> shader.cell.fred
    }
    cam (image "icon.camera") {
        snap  (tap  0)
        fake  (tog  0)
        real  (tog  1)
        face  (tog  1, image "icon.camera.flip") >> shader.pipe.camera.flip
        xfade (val .5)
    }
}
