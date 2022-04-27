sky.shader {
    _compute { type "compute", file "*.metal", on (0..1), buffer { version (0..1) } }
    cell {
    melt: _compute { file "cell.melt.metal" }
    fredkin: _compute { file "cell.fredkin.metal" }
    gas: _compute { file "cell.gas.metal" }
    average: _compute { file "cell.average.metal" }
    modulo: _compute { file "cell.modulo.metal" }
    fader: _compute { file "cell.fader.metal" }
    slide: _compute { file "cell.slide.metal" }
    drift: _compute { file "cell.drift.metal" }
    tunel: _compute { file "cell.timetunnel.metal" }
    zha: _compute { file "cell.zhabatinski.metal" repeat (11) buffer.bits (2..4 = 3) }
    }
    pipeline {
        record { type "record" file "record.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
        camera { type "camera" file "cell.camera.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
        camix { type "camix" file "cell.camix.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
        draw { type "draw" file "drawScroll.metal" on (0..1) buffer.scroll (x 0..1 = 0.5, y 0..1 = 0.5) }
        color { type "colorize" file "colorize.metal" buffer.bitplane (0..1) }
        render { type "render" file "render.metal" buffer { clip (x 0, y 0, w 1080, h 1920) repeat (x, y) mirror (x, y) } }
    }
}

