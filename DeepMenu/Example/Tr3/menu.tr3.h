menu {
    canvas (symbol "photo.artframe") {

        tile (image "icon.shader.tile.png") {
            mirror (vxy, x -1…1, y -1…1, symbol "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right") >> shader.pipe.mirror
            repeat (vxy, x -1…1, y -1…1, symbol "rectangle.grid.2x2" ) >> shader.pipe.repeat
        }
        scroll (image "icon.cell.scroll.png") {
            shift (vxy, x 0.5, y 0.5, image "icon.cell.scroll") >> shader.pipe.scroll
            tilt  (tog 0, image "icon.pen.tilt") // brushTilt
        }
        color(image "icon.pal.main") {
            fade  (val 0, symbol "slider.horizontal.below.rectangle")
            plane (val 0, symbol "square.3.layers.3d.down.right")
            zero  (tap, symbol "drop") >> sky.draw.fill(0)
            one   (tap, symbol "drop.fill")  >> sky.draw.fill(-1)
        }
        speed (image "icon.speed") {
            fps (seg 0…60=60, symbol "speedometer" ) >> sky.main.fps
            run (tog 1      , symbol "goforward") >> sky.main.run
        }
    }
    brush (symbol "paintbrush.pointed") {
        size  (val 0.5, symbol "circle.circle") >> sky.draw.brush.size
        press (tog 1  , image "icon.pen.press") >> sky.draw.brush.press
        tilt  (tog 1  , symbol "angle") >> sky.input.brush.tilt
    }
    cell (symbol "circle.grid.3x3") {
        fade  (val 2…3=2.2, image "icon.cell.fade" ) >> shader.cell.fade
        ave   (val 0.5    , image "icon.cell.ave"  ) >> shader.cell.ave
        melt  (val 0.5    , image "icon.cell.melt" ) >> shader.cell.melt
        tunl  (seg 0…5=1  , image "icon.cell.tunl" ) >> shader.cell.tunl
        //zha   (seg 0…6=2  , image "icon.cell.zha"  ) >> shader.cell.zha
        slide (seg 0…7=3  , image "icon.cell.slide") >> shader.cell.slide
        //fred  (seg 0…4=4  , image "icon.cell.fred" ) >> shader.cell.fred
    }
    cam (symbol "camera") {
        snap  (tap  0, symbol "camera.shutter.button")
        fake  (tog  0, symbol "face.dashed")
        real  (tog  1, symbol "face.smiling")
        face  (tog  1, symbol "arrow.triangle.2.circlepath.camera") >> shader.pipe.camera.flip
        xfade (val .5, symbol "slider.horizontal.below.rectangle")
    }
}
