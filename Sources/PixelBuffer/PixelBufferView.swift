#if canImport(UIKit)

import UIKit

public class PixelBufferView: UIView {
    
    public struct DisplayMode {
        
        public let pixelScale: CGFloat
        public let displaysGrid: Bool
        
        public init(pixelScale: CGFloat, displaysGrid: Bool) {
            self.pixelScale = pixelScale
            self.displaysGrid = displaysGrid
        }
        
        static public let `default`: Self = .init(pixelScale: 1.0, displaysGrid: false)
        static public let enlarged: Self = .init(pixelScale: 10.0, displaysGrid: true)
        
    }
    
    public var pixelBuffer: PixelBuffer? {
        didSet { self.prepareForDisplay() }
    }
    
    public var displayMode: DisplayMode = .default {
        didSet { self.prepareForDisplay() }
    }
    
    override public var intrinsicContentSize: CGSize {
        guard let pixelBuffer = self.pixelBuffer else { return UIView.noIntrinsicSize }
        
        let pixelScale = self.displayMode.pixelScale
        
        return .init(
            width: CGFloat(pixelBuffer.width) * pixelScale,
            height: CGFloat(pixelBuffer.height) * pixelScale
        )
    }
    
    public init(pixelBuffer: PixelBuffer) {
        super.init(frame: .zero)
        
        self.pixelBuffer = pixelBuffer
        self.prepareForDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
        guard
            !rect.isEmpty,
            let pixelBuffer = self.pixelBuffer,
            let drawingContext = UIGraphicsGetCurrentContext()
        else { return }
        
        if self.displayMode.displaysGrid {
            drawingContext.setStrokeColor(UIColor.black.cgColor)
            drawingContext.setLineWidth(1.0 / self.contentScaleFactor)
        }
        
        let pixelScale = rect.width / CGFloat(pixelBuffer.width)
    
        for y in 0..<pixelBuffer.height {
            for x in 0..<pixelBuffer.width {
                // Extract color components from pixel
                guard
                    case let yOffset = y * pixelBuffer.height,
                    case let pixel = pixelBuffer.pixels[yOffset + x],
                    let red = pixel.components.firstRed.map({ CGFloat($0.normalizedValue) }),
                    let green = pixel.components.firstGreen.map({ CGFloat($0.normalizedValue) }),
                    let blue = pixel.components.firstBlue.map({ CGFloat($0.normalizedValue) })
                else { continue }
                
                drawingContext.beginPath()
                drawingContext.addRect(.init(
                    x: CGFloat(x) * pixelScale,
                    y: CGFloat(y) * pixelScale,
                    width: pixelScale,
                    height: pixelScale
                ))
                drawingContext.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                drawingContext.closePath()
                
                drawingContext.drawPath(using: self.displayMode.displaysGrid ? .fillStroke : .fill)
            }
        }
    }
    
    private func prepareForDisplay() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay()
    }
    
}

#endif
