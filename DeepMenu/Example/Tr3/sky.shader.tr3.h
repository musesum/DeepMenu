sky.shader {
    _compute { type "compute" file "*.metal" on (0..1) buffer { version (0..1) } }
    cellMelt: _compute { file "cell.melt.metal" }
    cellFredkin: _compute { file "cell.fredkin.metal" }
    cellGas: _compute { file "cell.gas.metal" }
    cellAverage: _compute { file "cell.average.metal" }
    cellModulo: _compute { file "cell.modulo.metal" }
    cellFader: _compute { file "cell.fader.metal" }
    cellSlide: _compute { file "cell.slide.metal" }
    cellDrift: _compute { file "cell.drift.metal" }
    cellTimetunnel: _compute { file "cell.timetunnel.metal" }
    cellZhabatinski: _compute { file "cell.zhabatinski.metal" repeat (11) buffer.bits (2..4 = 3) }
    record { type "record" file "record.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
    cellCamera { type "camera" file "cell.camera.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
    cellCamix { type "camix" file "cell.camix.metal" on (0..1) buffer { version (0..1) } flip (0..1) }
    drawScroll { type "draw" file "drawScroll.metal" on (0..1) buffer.scroll (x 0..1 = 0.5, y 0..1 = 0.5) }
    colorize { type "colorize" file "colorize.metal" buffer.bitplane (0..1) }
    render { type "render" file "render.metal" buffer { clip (x 0, y 0, w 1080, h 1920) repeat (x, y) mirror (x, y) } }
}

