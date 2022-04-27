panel.cell.fader: _cell {
    base {
        title "Fader"
        icon "icon.cell.fader.png"
    }
    controls {
        ruleOn.icon "icon.cell.fader.png"
        ruleOn.value >> sky.shader.cellFader.on
        version.value (0..1 = 0.5) >> sky.shader.cellFader.buffer.version
        bitplane.value (0..1 = 0.2)
    }
}
