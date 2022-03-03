//  Created by warren on 3/2/22.


/// Menu structure for replacing DeepMuse app's Tr3Thumb* + Panel.*.tr3.h
canvas {
    fill {
        zero { type "trigger" title "Fill Zero" } // fillZero
        one { type "trigger" title "Fill Ones" } // fillOne
    }
    bitplane { type "slider" range (0...1) title "Bit Plane" }
    tile {
        mirror { type "xy" title "Mirror" } // mirrorBox
        repeat { type "xy" title "Repeat" } // repeatBox
    }
    scroll {
        box { type "xy" range (0...1) title "Screen Scroll"  } // scrollBox
        tilt { type "switch" title "Brush Tilt"  } // brushTilt
    }
    speed {
        fps { type "slider" range (0...1) title "Frames per second"  }
        pause { type "switch" title "pause" }
    }
}
brush {
    press { type "switch"  range (x 0..1) title "Pressure" } // brushPress
    size { type "slider" range (x 0..1, y 0..1) title "Size"  }  // brushSize
}
cell {
    fade { type "slider" range (0...1) title "fade away"  }
    ave { type "slider" range (0...1) title "average"  }
    melt { type "slider" range (0...1) title "reaction"  }
    tunl { type "segment" range (0...5) title  "time tunnel"  }
    zha { type "segment" range (0...6) title  "zhabatinski"  }
    slide { type "segment" range (0...7) title  "slider bitplanes"  }
    fred { type "segment" range (0...4) title  "fredkin"  }
}
camera {
    fake { type "switch" range (0...1) title "false color" }
    real { type "switch" range (0..1) title "real color" }
    mix { type "slider" range (0...1) title "mix false/real" }
    snap { type "trigger" title "snapshot" }
}

