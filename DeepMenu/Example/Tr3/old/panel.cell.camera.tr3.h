panel.cell.camera: _camera {

    base {
        type "camera"
        title "Camera"
        icon "icon.camera.png"
    }
    controls {
        cameraOne.value >> sky.shader.cellCamera.on
        cameraTwo.value >> sky.shader.cellCamix.on
        version.value (0..1 = 0.5) >> sky.shader.cellCamix.buffer.version
        bitplane.value 0..1 >> sky.shader.colorize.buffer.bitplane
    }
}
