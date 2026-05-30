draw ('draw on metal layer') {
    screen.fill(x 0…1=0, 'fill cellular automata universe')
    brush ('type of brush and range') {
        size  (x 1…128=10:10, 'range of radius')
        press (x 0…1=1, 'pressure changes size')
        index (x 1…255=127, 'index in 256 color palette')
    }
    line ('place holder for line drawing') {
        prev (x 0…1, y 0…1,'staring point of segment')
        next (x 0…1, y 0…1,'endint point of segment')
    }
    dot(on 1, log 0, 'use MIDI MPI input to drawing dots on canvas') {
        note {
            on(chan, num, velo, <- midi.input.note.on)
            off(chan, num, velo, <- midi.input.note.off)
        }
        after(chan, val, <- midi.input.afterTouch)
        wheel(chan, val, <- midi.input.pitchWheel)
        slide(chan, cc == 74, val, <- midi.input.controller)
        clear(<- draw.screen.fill)
    }
    ripple(on 1, log 0, 'use MIDI MPE to ripple colors through pal0/pal1 ') {
        note {
            on(chan, num, velo, <- midi.input.note.on)
            off(chan, num, velo, <- midi.input.note.off)
        }
        after(chan, val, <- midi.input.afterTouch)
        wheel(chan, val, <- midi.input.pitchWheel)
        slide(chan, cc == 74, val, <- midi.input.controller)
        clear(<- draw.screen.fill)
    }
}
