panel.cell.fredkin: _cell {
    base {
        title "Fredkin"
        icon "icon.cell.fredkin.png"
    }
    controls {
        ruleOn.icon "icon.cell.fredkin.png"
        ruleOn.value >> sky.shader.cellFredkin.on
        version.value (0..1 = 0.5) >> sky.shader.cellFredkin.buffer.version
    }
}
