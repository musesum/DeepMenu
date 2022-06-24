sky { // visual music program
    main { // main controls
        frame (0)        // frame counter
        fps (1…60 = 60) // frames per second
        run (1)          // currently running
    }
    pipe {              // default metal pipeline at atartup
        draw "draw"         // drawing layer
        ave "compute"       // compute layer
        color "colorize"   // colorizing layer
        render "render"    // render layer al
    }

    color { // false color mapping palette
        pal0 "roygbik"  // palette 0: (r)ed (o)value (y)ellow …
        pal1 "wKZ"      // palette 1: (w)hite blac(K) fractali(Z)e
        xfade (0…1=0.5) // cross fade between pal0 and pal1
    }
    input { // phone and tablet pencil input

        azimuth (x -0.2…0.2, y -0.2…0.2)  // pen tilt
        accel   (x -0.3…0.3, y -0.3…0.3, z -0.3…0.3)  // accelerometer

        accel  (0…1)       // use accel //? accel.on
        radius (1…92=9)  // finger silhouette
        tilt   (0…1)       // use tilt
        force  (0…0.5)     // pen pressure
        >> sky.draw.brush.size
    }
    draw { // draw on metal layer
        fill(0) 
        brush { // type of brush and value
            type "dot"          // draw a circle
            size (1…64 = 10)    // value of radius
            press(0…1 = 1)      // pressure changes size
            index(1…255 = 127)  // index in 256 color palette
                                // <<(osc.tuio.z osc.manos˚z)
                                // redirect from OSC
        }
        line { // place holder for line drawing
            prev (x 0…1, y 0…1) // staring point of segment
            next (x 0…1, y 0…1) // endint point of segment
        }
        scroll {
            offset (x  0…1,   y 0…1)
            shift  (x -1…1=0, y -1…1=0)
        }
    }
}
