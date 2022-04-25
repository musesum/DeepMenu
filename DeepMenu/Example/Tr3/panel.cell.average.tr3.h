panel.cell.average: _cell {
    base: {
        title: "Average",
        icon: "icon.cell.average.png"
    }
    controls {
        ruleOn.icon: "icon.cell.average.png",
        ruleOn.value: >> sky.shader.cellAverage.on
        version.value: (0..1 = 0.4) >> sky.shader.cellAverage.buffer.version
    }
}
