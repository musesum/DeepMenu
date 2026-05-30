pipe (on 1) {

    draw (on 1) {
        in (texture, <- cell.out)
        out (texture, archive, 'archive: save snapshot of drawing surface')
        shift (buffer, x 0…1=0.5,  y 0…1=0.5)
    }
    camera (on 0) {
        out (texture)
        front (buffer, x 0)
    }
    cell (on 1) {
        fake (texture, <- draw.out)
        real (texture, <- (draw.out, camera.out))
        out (texture)
        rule (on 1) {
            slide(on 1) { version (buffer, x 0…7 : 3)   loops (buffer, z 0) }
            zha  (on 0) { version (buffer, x 0…6 : 2)   loops (buffer, z 10) }
            ave  (on 0) { version (buffer, x 0…1 : 0.5) loops (buffer, y 0…99=0) }
            fade (on 0) { version (buffer, x 0…2 : 0)   loops (buffer, y 0…32=0) }
            melt (on 0) { version (buffer, x 0…1 : 0.5) loops (buffer, y 0…32=0) }
            tunl (on 0) { version (buffer, x 0…5 : 1)   loops (buffer, y 0…32=0) }
            fred (on 0) { version (buffer, x 0…4 : 4)   loops (buffer, y 0…32=0) }
            *(-> *(on 0)) // solo only one rule // no tooltip here
            ˚version(-> ..(on 1)) // changing `version` auto switches rule
        }
    }
    color (on 1) {
        in (texture, <- (camera.out, cell.out))
        pal (texture, w 256, h 1)
        out (texture)
        plane (buffer, y 0…1)
        height(buffer, x 0…1=0)
    }
    camix (on 0, <- camera) {
        in  (texture, <- color.out)
        cam (texture, <- camera.out)
        out (texture)
        mixcam (buffer, x 0…1=1)
    }
    tile (on 1) {
        in (texture, <- (color.out, camix.out))
        out (texture)
        repeat (buffer, x -1…1=0, y -1…1=0)
        mirror (buffer, x  0…1=0, y  0…1=0)
    }
    render (on 1) {
        in (texture, <- tile.out)
        map (on 1)  {
            flat(on 1)
            cube(on 1) {
                cudex(texture)
                mixcube (buffer, x 0…1 : 1, y 0…1 : 1, ^- sky.main.anim)
            }
        }
        plato (on 1) {
            cube (texture, <- map.cube.cudex)
            pal  (texture, <- color.pal)
            range01 (buffer, x 0…1)
            shading (buffer)
        }
    }
}
