hand(svg "hands.both") {

    left (svg "hand.left") {
        thumb  {      knuc base inter tip }
        index  { meta knuc base inter tip }
        middle { meta knuc base inter tip }
        ring   { meta knuc base inter tip }
        little { meta knuc base inter tip }
        wrist
        forearm
    }
    right (svg "hand.right") {
        thumb  {      knuc base inter tip }
        index  { meta knuc base inter tip }
        middle { meta knuc base inter tip }
        ring   { meta knuc base inter tip }
        little { meta knuc base inter tip }
        wrist
        forearm
    }
    
    hand˚.('decorate joints with expressions',
           x -0.30 … 0.30, y 0.80 … 1.20, z -0.50 … -0.01,
           time, phase, taps, joint, on 0, state)

    hand˚tip('set finger tips on',
             x -0.30 … 0.30, y 0.80 … 1.20, z -0.50 … -0.01,
             time, phase, taps, joint, on 1, state)

    pinch {
        left  (<- hand.left.index.tip)
        right (<- hand.right.index.tip)
    }

    draw ('draw on canvas. see JointCanvasState:: parseCanvas',
          <- hand˚middle.tip)
    
    zoom ('script only dispatch to zoom',
          <- hand˚ring.tip,
          -> plato.zoom(y: z))
    
    material ('script only dispatch to change material',
              <- hand.right.little.tip,
              -> plato.material)
    
    alpha ('script only dispatch to change material',
           <- hand.left.little.tip,
           -> canvas.alpha)
}
