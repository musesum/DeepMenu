more (svg "icon.more") {

    anim(val, 0…1:0.24,
         sym "bolt.fill",
         <> sky.main.anim)

    fps (val, 0_60=60,
         img "icon.speed",
         <> sky.main.fps)

    bonjour (peer "bonjour",
             sym "bonjour",
             <> sky.network.bonjour)

    chat('chat',
         sym "sparkle",
         <> sky.main.search)
}
music(sym "music.note")
mic(sym "music.microphone")
