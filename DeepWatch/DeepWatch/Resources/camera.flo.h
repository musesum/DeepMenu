camera(sym "camera")  {
    
    stream  ('turn camera on',
             tog, x 0,
             sym "video",
             <> pipe.camera(on: x),
             -> cubemap(x: 0))
    
    front   ('use front facing or back facing',
             tog, x 1,
             svg "icon.camera.facing",
             <> pipe.camera.front)
    
    cubemap ('map to a cube or flat presentation',
             tog, x 1,
             sym "cube",
             <> pipe.render.map.cube.mixcube)
    
    mix     ('face between real and false color',
             xy, x 1, y 0…1=0,
             sym "camera.filters",
             <> (pipe.camix.mixcam,
                 pipe.cell.rule˚loops(y)))
    
    color   ('shift false color around'
             xy,  x 0…1=0, y 0…1=0,
             sym "paintpalette"
             <> canvas.color)
}
