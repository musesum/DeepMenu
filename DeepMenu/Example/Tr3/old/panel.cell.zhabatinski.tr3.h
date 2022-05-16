panel.cell.zha: _cell {
    base {
        title "Zhabatinski"
        icon "icon.cell.zha.png"
    }
    controls {
        ruleOn.icon "icon.cell.zha.png"
        ruleOn.value >> sky.shader.cellZhabatinski.on
        version.value (0..1 = 0.75) >> sky.shader.cellZhabatinski.buffer.version
    }
}
