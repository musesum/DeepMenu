canvas (svg "icon.canvas") {

    color ('shift color frame and palette fade',
           xy, x 0…1, y 0…1,
           sym "paintpalette",
           <> (pipe.color.plane,
               sky.color.xfade),
           ^- sky.main.anim)

    repeat ('repeat canvas, 0 is 1:1',
            xy, x -1…1=0, y -1…1=0,
            svg "icon.repeat.arrows",
            <> pipe˚.repeat,
            -> (midi.cc.skypad.repeatX(val: x),
                midi.cc.skypad.repeatY(val: y)),
            ^- sky.main.anim)

    mirror ('mirror repetitions',
            xy, x 0…1=0, y 0…1=0,
            svg "icon.mirror",
            <> pipe˚.mirror,
            ^- sky.main.anim)

    shift ('amount of screen shift, double tap to stop',
           xy,
           x 0…1=0.5, y 0…1=0.5,
           svg "icon.direction",
           <> pipe.draw.shift,
           ^- sky.main.anim)

    alpha (xy, x 0…1=0, y 0…1=0,
           sym "cube.transparent",
           -> (plato.alpha(y: y)
               render.map.cube.mixcube(y: x)))

}
