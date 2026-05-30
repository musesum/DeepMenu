sky ('visual music synth') {
    main ('main controls') {
        run (x 0…1=1,'currently running')
        anim(x 0…1=0.5,'animation transition speed')
        glass(x 0…1=1, 'glass style on os26' )
        chat
    }
    network {
        bonjour('bonjour status')
        follow (x 0…1=1,'follow remote events -- not implemented')
        midi   (x 0…1=1,'follow midi events -- not implemented')
    }

    color ('false color mapping palette') {
        pal0 ("roygbik", 'red orange yellow green blue indigo black')
        pal1 ("wKZ", 'white & blacK with capital K meaning both sides, Z means with Zeno fractal')
        xfade (x 0…1=0.5, 'cross fade btween pal0 and pal1')
    }
    input ('phone and tablet pencil input') {
        azimuth (x -0.2…0.2, y -0.2…0.2, -> pipe.draw.shift)
        accel   (x -0.3…0.3, y -0.3…0.3, z -0.3…0.3,'accelerometer')
        radius  (x 1…92=9, 'for iPhone, finger silhouette changes brush size')
        tilt    (x 0…1=0,  'for iPad pen, allow tilt to shift screen')
        force   (x 0…0.5, -> draw.brush.size, 'iPad pen, pressure with change brush size')
    }
}
