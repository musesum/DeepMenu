plato ('platonic solids',
       columns 2,
       svg "icon.plato.icosa") {

    show ('show / hide the platonic object',
          tog, x 1,
          sym "eye",
          <> pipe.render.plato(on : x))

    material ('gradient xy and transparency z',
              xyz, x 0…1=0, y 0…1=0, z 0…1=1,
              svg "icon.opacity",
              -> zoom(y:z)
              ^- sky.main.anim)

    harmonic ('number of face triangle subdivisions',
              seg, x 0_6,
              svg "icon.subtriangle")

    phase ('phase between tetra, cube, octa, dodec, icosa',
           seg, x 0_10 : 1,
           svg "icon.plato.phase")

    convex ('inward / outward of subdivided triangles',
            val, x 0.9…1.1 : 0.98,
            svg "icon.convex")

    zoom ('zoom into and around platonic object',
          val, y 0…1=0,
          sym "square.arrowtriangle.4.outward",
          ^- sky.main.anim)

    alpha (val, y 0…1=1,
           sym "cube.transparent",
           ^- sky.main.anim)

    cubemap ('show cubemap or flat screen (ignored on VisionPro)',
             tog, x 0…1 : 1,
             sym "cube",
             -> pipe.render.map.cube.mixcube(x: x))

    _run ('run the platonic transformation',
          tog, x 0_1 : 1,
          svg "icon.counter")

    _wire ( 'show wireframe',
           tog, x 0_1 : 0,
           svg "icon.wireframe")

    _counter('absolute counter',
             svg "icon.counter")
}

