shader {
    cell {
        fade  (compute, val 0.5   , file "cell.fader.metal", on 1)
        ave   (compute, val 0.5   , file "cell.ave.metal"  , on 0)
        melt  (compute, val 0.5   , file "cell.melt.metal" , on 0)
        tunl  (compute, seg 0..5=1, file "cell.tunl.metal" , on 0)
        slide (compute, seg 0..7=3, file "cell.slide.metal", on 0)
        fred  (compute, seg 0..4=4, file "cell.fred.metal" , on 0)
        zha   (compute, seg 0..6=2, file "cell.zha.metal"  , on 0,
               repeat 11, bits 2..4=3) // buffer.bits
    }
    pipe {
        record (record, tog 0, file "record.metal"     ) // flip?
        camera (camera, tog 0, file "cell.camera.metal") // flip?
        camix  (camix , tog 0, file "cell.camix.metal" ) // flip?

        scroll (draw  , vxy, x 0.5, y 0.5, file "drawScroll.metal") // scrollBox
        render (render, box, x 0, y 0, w 1080, h 1920, file "render.metal")
        repeat (render, vxy, x 0, y 0) // repeatBox
        mirror (render, vxy, x 0, y 0) // mirrorBox
        color  (color , val 0, file "colorize.metal")
    }
}

