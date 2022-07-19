#if canImport(UIKit)

import UIKit

public class PixelBufferView: UIView {
    
    public struct DisplayMode {
        
        let pixelScale: CGFloat
        let displaysGrid: Bool
        
        init(pixelScale: CGFloat, displaysGrid: Bool) {
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
        guard let size = self.pixelBuffer?.size else { return UIView.noIntrinsicSize }
        
        let pixelScale = self.displayMode.pixelScale
        return .init(width: CGFloat(size.width) * pixelScale, height: CGFloat(size.height) * pixelScale)
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
        
        let pixelScale = rect.width / CGFloat(pixelBuffer.size.width)
    
        for x in 0..<pixelBuffer.size.width {
            for y in 0..<pixelBuffer.size.height {
                guard
                    case let pixel = pixelBuffer.pixels[x * y],
                    pixel.components.count >= 3,
                    case let red = CGFloat(pixel.components[0]) / 255.0,
                    case let green = CGFloat(pixel.components[1]) / 255.0,
                    case let blue = CGFloat(pixel.components[2]) / 255.0
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
