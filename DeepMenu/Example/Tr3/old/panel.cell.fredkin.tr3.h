panel.cell.fred: _cell {
    base {
        title "Fredkin"
        icon "icon.cell.fred.png"
    }
    controls {
        ruleOn.icon "icon.cell.fred.png"
        ruleOn.value >> sky.shader.cellFredkin.on
        version.value (0..1 = 0.5) >> sky.shader.cellFredkin.buffer.version
    }
}
