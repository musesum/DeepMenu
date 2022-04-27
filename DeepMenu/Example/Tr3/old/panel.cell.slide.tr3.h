panel.cell.slide: _cell {
    base {
        title "Slide Bit Planes"
        icon "icon.cell.slide.png"
    }
    controls {
        ruleOn.icon "icon.cell.slide.png"
        ruleOn.value >> sky.shader.cellSlide.on
        version.value >> sky.shader.cellSlide.buffer.version
    }
}
