cell (columns 2, svg "icon.cellular.automata") {

    slide ('Slide Bit Planes',
           seg, x 0_7=3,
           img "icon.cell.slide",
           <> pipe.cell˚slide.version)
    
    zha   ('Cellular Automata Belousov–Zhabotinsky spirals',
           seg, x 0_6=2,
           img "icon.cell.zha",
           <> pipe.cell˚zha.version)
    
    ave   ('Cellular Automata Averaging nearby pixels',
           val, x 0…1=0.5,
           img "icon.cell.ave",
           <> pipe.cell˚ave.version)
    
    fade  ('Fade out to zero -- interesting in higher bit planes',
           val, x 0…2=1,
           img "icon.cell.fade",
           <> pipe.cell˚fade.version)
    
    melt  ('Cellular Automata Reaction Diffusion rule - flashy at first',
           val, x 0…1=0.5,
           img "icon.cell.melt",
           <> pipe.cell˚melt.version)
    
    tunl  ('Cellular Automata Tube Tunnel rule',
           seg, x 0_5=1,
           img "icon.cell.tunl",
           <> pipe.cell˚tunl.version)
    
    fred  ('Cellular Automata Fredkin rule',
           seg, x 0_4=4,
           img "icon.cell.fred",
           <> pipe.cell˚fred.version)
}

