# PixelBuffer
 
`PixelBuffer` represents an abstract, 2D arrangement of pixels that can be
individually addressed. Pixels can have any number of components, and each
component can be backed by any fixed-width integer type.

> Note: `PixelBuffer` relies on Swift's recent expanded support for existential
types and requires Xcode 14 or higher.

```swift
var pixels: [Pixel] = []
for _ in 0..<25 {
    pixels.append(.init(components: [
        .red(Pixel.randomComponent()),
        .green(Pixel.randomComponent()),
        .blue(Pixel.randomComponent())
    ]))
}

guard let pixelBuffer: PixelBuffer = try? .init(pixels: pixels, width: 5, height: 5) else { return }

let pixelBufferView: PixelBufferView = .init(pixelBuffer: pixelBuffer)
pixelBufferView.displayOptions = .init(pixelScale: 50.0, displaysGrid: true)

self.view.addSubview(pixelBufferView)
```
