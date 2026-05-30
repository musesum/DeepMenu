midi('musical instrument device interface') {
    input ('MIDI input') {
        note('note on/off from 0 thru 127') {
            on  (chan 1_32, num 0_127, velo 0_127, port 1_16, time 0)
            off (chan 1_32, num 0_127, velo 0_127, port 1_16, time 0)
        }
        afterTouch (chan 1_32, num 0_127, val 0_127, port 1_16, time 0)
        pitchWheel (chan 1_32, val 0_16384=8192, port 1_16, time 0)
        program    (chan 1_32, num 0_255, port 1_16, time 0)
        nrpn       (chan, num 0_16383, val 0…1, time 0, -> skypad˚.)
        controller (chan 1_32, cc 0_127, val 0_127,port 1_16, time 0, -> cc.roli˚.)
    }
    output : input { controller(<- cc˚.) }

    cc {
        roli {
            lightpad {
                mixer('roli default mixer block') {
                    button1(cc == 102, val 0_1, -> canvas.fill(x: 0))
                    button2(cc == 103, val 0…1, -> canvas.shift(x: val/2, y: val/2))
                    button3(cc == 104, val 0_1, -> plato.cubemap(x: val))
                    button4(cc == 105, val 0_1, -> plato.show(x: val))

                    fader1(cc == 112, val 0…1, <> canvas.color(x: val))
                    fader2(cc == 113, val 0…1, <> canvas.color(y: val))
                    fader3(cc == 114, val 0…1, <> plato.harmonic(x: val))
                    fader4(cc == 115, val 0…1, <> plato.zoom(y: val))
                }
            }
            loop('Roli Loop Melodics preset, edited cc range to 92-101') {
                mode   (cc ==  92, val 0_127)
                mute   (cc ==  93, val 0_127)
                metro  (cc ==  94, val 0_127)
                skip   (cc ==  95, val 0_127)
                back   (cc ==  96, val 0_127)
                play   (cc ==  97, val 0_127)
                record (cc ==  98, val 0_127)
                learn  (cc ==  99, val 0_127)
                prev   (cc == 100, val 0_127)
                next   (cc == 101, val 0_127)
            }
        }
        main {
            wheel       (chan, num ==  1, val, time)
            volume      (chan, num ==  7, val, time)
            balance     (chan, num ==  8, val, time)
            panPosition (chan, num == 10, val, time)
            expression  (chan, num == 11, val, time)
            controller  (chan, num in 32_63, val, time)
            portamento {
                time   ( chan, num ==  5, val, time)
                amount ( chan, num == 84, val, time)
            }
        }
        pedal {
            hold    (chan, num == 64, val, time)
            porta   (chan, num == 65, val, time)
            sosta   (chan, num == 66, val, time)
            _soft   (chan, num == 67, val, time)
            _legato (chan, num == 68, val, time)
            _hold2  (chan, num == 69, val, time)
        }
    }
}
