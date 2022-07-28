#if canImport(UIKit)

import UIKit

// MARK: Types
// MARK: -

/// A view that can visualize a `PixelBuffer`.
///
/// `PixelBufferView` can render an associated pixel buffer and display the
/// pixels using a variety of display options.
///
/// - Note: This view is intended to define its own intrinsic content size for
/// layout purposes based on its configuration; its display may not look as
/// intended if explicit size constraints are placed on it.
///
public class PixelBufferView: UIView {
    
    // MARK: Properties
    
    /// The pixel buffer to be displayed by this view.
    ///
    /// When this value changes, the view reconfigures itself to redraw and lay
    /// itself out again.
    ///
    /// - SeeAlso: `displayOptions`
    ///
    public var pixelBuffer: PixelBuffer? {
        didSet { self.prepareForDisplay() }
    }
    
    /// The display options to use when rendering this view's pixel buffer.
    ///
    /// When this value changes, the view reconfigures itself to redraw and lay
    /// itself out again.
    ///
    /// - SeeAlso: `pixelBuffer`
    ///
    public var displayOptions: DisplayOptions = .default {
        didSet { self.prepareForDisplay() }
    }
    
    // See `UIView`.
    override public var intrinsicContentSize: CGSize {
        guard let pixelBuffer = self.pixelBuffer else { return UIView.noIntrinsicSize }
        
        let pixelScale = self.displayOptions.pixelScale
        
        return .init(
            width: CGFloat(pixelBuffer.width) * pixelScale,
            height: CGFloat(pixelBuffer.height) * pixelScale
        )
    }
    
    // MARK: Initialization
    
    /// Creates a new pixel buffer view from an existing pixel buffer.
    ///
    /// - Parameter pixelBuffer: A pixel buffer to display in this view.
    ///
    public init(pixelBuffer: PixelBuffer) {
        super.init(frame: .zero)
        
        self.pixelBuffer = pixelBuffer
        self.prepareForDisplay()
    }
    
    // See `NSCoding`.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Rendering the Pixel Buffer
    
    // See `UIView`.
    override public func draw(_ rect: CGRect) {
        guard
            !rect.isEmpty,
            let pixelBuffer = self.pixelBuffer,
            let drawingContext = UIGraphicsGetCurrentContext()
        else { return }
        
        // If the pixel grid is to be displayed, set the stroke width to a
        // single logical pixel regardless of the display scaling.
        if self.displayOptions.displaysGrid {
            drawingContext.setStrokeColor(UIColor.black.cgColor)
            drawingContext.setLineWidth(1.0 / self.contentScaleFactor)
        }
        
        let pixelScale = rect.width / CGFloat(pixelBuffer.width)
    
        // Enumerate each pixel in a 2D grid
        for y in 0..<pixelBuffer.height {
            for x in 0..<pixelBuffer.width {
                // Extract color components from pixel
                // TODO (SP): Work with any pixel format
                guard
                    case let yOffset = y * pixelBuffer.height,
                    case let pixel = pixelBuffer.pixels[yOffset + x],
                    let red = pixel.components.firstRed.map({ CGFloat($0.normalizedValue) }),
                    let green = pixel.components.firstGreen.map({ CGFloat($0.normalizedValue) }),
                    let blue = pixel.components.firstBlue.map({ CGFloat($0.normalizedValue) }),
                    case let alpha = pixel.components.firstAlpha.map({ CGFloat($0.normalizedValue) }) ?? 1.0
                else { continue }
                
                // Add a rect to the drawing context that represents a single
                // pixel, including the display scaling factor.
                drawingContext.beginPath()
                drawingContext.addRect(.init(
                    x: CGFloat(x) * pixelScale,
                    y: CGFloat(y) * pixelScale,
                    width: pixelScale,
                    height: pixelScale
                ))
                drawingContext.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
                drawingContext.closePath()
                
                drawingContext.drawPath(using: self.displayOptions.displaysGrid ? .fillStroke : .fill)
            }
        }
    }
    
    /// Prepares the view to display its pixel buffer by laying itself out and
    /// enqueuing a new drawing pass.
    private func prepareForDisplay() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay()
    }
    
}

// MARK: -

extension PixelBufferView {
    
    /// Options used to display a pixel buffer in a variety of ways.
    public struct DisplayOptions {
        
        // MARK: Properties
        
        /// The scale at which each pixel should be rendered.
        ///
        /// This value effectively multiplies the width and height of each pixel
        /// so it can be visualized at a size larger or smaller than a single
        /// on screen pixel.
        ///
        public let pixelScale: CGFloat
        
        /// Whether or not a grid is drawn around each pixel.
        public let displaysGrid: Bool
        
        // MARK: Initialization
        
        /// Creates a new set of display options.
        ///
        /// - Parameters:
        ///   - pixelScale: The scale at which each pixel should be displayed.
        ///   - displaysGrid: Whether or not a grid is drawn between each pixel.
        ///
        public init(pixelScale: CGFloat, displaysGrid: Bool) {
            self.pixelScale = pixelScale
            self.displaysGrid = displaysGrid
        }
        
        // MARK: Common Definitions
        
        /// The default display options, which render a pixel buffer at its
        /// native scale with no grid.
        static public let `default`: Self = .init(pixelScale: 1.0, displaysGrid: false)
        
        /// Display options for an enlarged rendering of a pixel buffer,
        /// including a grid to easily distinguish each pixel.
        static public let enlarged: Self = .init(pixelScale: 10.0, displaysGrid: true)
        
    }
    
}

#endif
