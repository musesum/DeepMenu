brush ('brush',
       sym "paintbrush.pointed") {

    index ('index',
          val, x 1_255=255,
          sym "square.stack.3d.up",
          <> draw.brush.index)

    size  ('fixed brush size',
           val, x 1_128=12 : 12,
           svg "icon.size.dot",
           <> draw.brush.size)

    press ('set on to let iPad pencil or AVP depth change size',
           tog, x 1,
           sym "scribble.variable",
           <> draw.brush.press)

    tilt  ('set on to let iPad tilt shift screen',
           tog, x 0,
           sym "angle",
           <> sky.input.tilt)

    fill  ('erase screen with fill color',
           val, x 0…1=0 : 0,
           sym "drop",
           <> draw.screen.fill)
}

