panel.cell.modulo: _cell {
    base {
        title "Modulo"
        icon "icon.cell.modulo.png"
    }
    controls {
        ruleOn.icon "icon.cell.modulo.png"
        ruleOn.value >> sky.shader.cellModulo.on
        version.value >> sky.shader.cellModulo.buffer.version
    }
}
