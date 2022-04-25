panel.cell.melt: _cell {
    base {
        title "Melt"
        icon "icon.cell.melt.png"
    }
    controls {
        ruleOn.icon "icon.cell.melt.png"
        ruleOn.value >> sky.shader.cellMelt.on
        version.value >> sky.shader.cellMelt.buffer.version
        fillZero.value (16777182)  // 00ffffde
        fillOne.value (16777182)   // ffffffde
    }
}
