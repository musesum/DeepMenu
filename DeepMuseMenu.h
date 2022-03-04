//  Created by warren on 3/2/22.

enum menuTypes { case pod, trigger, slider, boxXY, toggle, segment }
/// Menu structure for replacing DeepMuse app's Tr3Thumb* + Panel.*.tr3.h

canvas(type: .pod, title: "canvas", icon: "icon.drop.clear", sub: [
    fill(type: .pod, title: "fill", icon: "icon.speed.png", sub: [
        plane(type: .slider, title: "Bit Plane", range: [0...1]),
        zero (type: .pad, title: "Fill Zero", range: [0...1], icon: "icon.drop.clear"), // fillZero
        one  (type: .pad, title: "Fill Ones", range: [0...1], icon: "icon.drop.gray" ), // fillOne
    ]),
    tile(type: .pod, title: "tile", icon: "icon.shader.tile.png", sub: [
        mirror (type: .boxXY, title: "Mirror", range: [0...1, 0...1], icon: "icon.pearl.white.png"), // mirrorBox
        repeat (type: .boxXY, title: "Repeat", range: [0...1, 0...1], icon: "icon.pearl.white.png"), // repeatBox
    ]),
    scroll(type: .pod, title: "scroll", icon: "icon.cell.scroll.png", sub: [
        box  (type: .boxXY,  title: "Screen Scroll", range: [0...1, 0...1], icon: "icon.cell.scroll.png"),  // scrollBox
        tilt (type: .toggle, title: "Brush Tilt"   , range: [0...1], icon: "icon.pen.tilt.png") // brushTilt
    ])
    color(type: .pod, title: "color", icon: "icon.pal.main.png", sub: [
        fade (type: .boxXY,  title: "Screen Scroll", range: [0...1, 0...1], icon: "icon.scroll.png"),  // scrollBox
        tilt (type: .toggle, title: "Brush Tilt"   , range: [0...1], icon: "icon.pen.tilt.png") // brushTilt
    ])
])
speed(type: .pod, title: "speed", icon: "icon.speed.png", sub: [
    fps   (type: .slider, title: "fps"  , range: [0...1], icon: "icon.speed.png"),
    pause (type: .toggle, title: "pause", range: [0...1], icon: "icon.thumb.x.png"),
])
brush(type: .pod, title: "brush", icon: "icon.cell.brush.png", sub: [
    size  (type: .slider, title: "brush size", range: [0..1], icon: "icon.pen.press.png"), // brushSize
    press (type: .toggle, title: "pen press" , range: [0..1], icon: "icon.pen.press.png"), // brushPress
    tilt  (type: .toggle, title: "pen title" , range: [0..1], icon: "icon.pen.tilt.png"), // brushPress
])
cell(type: .pod, title: "cell", sub: [
    fade  (type: .slider,  title: "fade away"    , range: [0...1], icon: "icon.cell.fader"),
    ave   (type: .slider,  title: "average"      , range: [0...1], icon: "icon.cell.average"),
    melt  (type: .slider,  title: "reaction"     , range: [0...1], icon: "icon.cell.melt"),
    tunl  (type: .segment, title: "time tunnel"  , range: [0...5], icon: "icon.cell.time"),
    zha   (type: .segment, title: "zhabatinski"  , range: [0...6], icon: "icon.cell.zhabatinski"),
    slide (type: .segment, title: "slide planes" , range: [0...7], icon: "icon.cell.slide.png"),
    fred  (type: .segment, title: "fredkin"      , range: [0...4], icon: "icon.cell.fredkin.png"),
])
camera(type: .pod, title: "camera", icon: "icon.camera.png", sub: [
    fake (type: .toggle, title: "false color"   , range: [0...1], icon: "icon.camera.png"),
    real (type: .toggle, title: "real color"    , range: [0...1], icon: "icon.camera.png"),
    face (type: .toggle, title: "facing"        , range: [0...1], icon: "icon.camera.flip.png"),
    xfade(type: .slider, title: "cross fade"    , range: [0...1], icon: "icon.pearl.white.png"),
    snap (type: .pad,    title: "snapshot"      , range: [0...1], icon: "icon.camera.png")
])

