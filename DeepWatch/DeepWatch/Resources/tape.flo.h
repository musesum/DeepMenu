tape (share 0, 'record playback loop', sym "recordingtape") {
    record (tog, x 0, -> play(x 0)) {
        _on  (sym "record.circle.fill")
        _off (sym "square.fill")
    }
    play (tog, x 0, -> record(x 0)) {
        _on  (sym "play.fill")
        _off (sym "play")
    }
    loop (menu 0, tog, x 1) {
        _on  (sym "arrow.trianglehead.clockwise")
        _off (sym "arrow.forward.to.line.compact")
    }
    learn (tog, x 0) {
        _on  (sym "graduationcap.fill")
        _off (sym "graduationcap")
    }
    beat (reflect 1, tap, x 0) {
        _on  (svg "icon.heartbeat.fill")
        _off (svg "icon.heartbeat")
    }
    panic('panic',
          tog, x 1,
          svg "icon.panic")

}
