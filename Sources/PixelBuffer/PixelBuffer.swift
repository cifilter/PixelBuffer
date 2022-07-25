import Foundation

/// A 2D arrangement of pixels that constitute a complete buffer of pixel data.
///
/// A pixel buffer stores an ordered collection of pixels as well as the width
/// and height of the buffer. Together, this data describes a complete buffer of
/// pixel data, commonly used to represent an image.
///
public struct PixelBuffer {
    
    // MARK: Properties
    
    public let pixelFormat: PixelFormat = .undefined
    
    /// The individual pixels that comprise the total buffer.
    public let pixels: [Pixel]
    
    /// The width of the buffer. Along with `height`, the product of these
    /// values must match the total count of `pixels`.
    public let width: Int
    
    /// The height of the buffer. Along with `width`, the product of these
    /// values must match the total count of `pixels`.
    public let height: Int
    
    // MARK: Initialization
    
    /// Creates a new pixel buffer from raw pixels.
    ///
    /// - Parameters:
    ///   - pixels: The pixels that completely describe a full pixel buffer.
    ///   - width: The width of the buffer.
    ///   - height: The height of the buffer.
    ///
    /// `PixelBuffer` checks for buffer validity at initialization time rather
    /// than at run time. Therefore, this initializer can `throw` if an invalid
    /// buffer is specified.
    ///
    /// - SeeAlso: `PixelBuffer.InitializationError`
    ///
    public init(pixels: [Pixel], width: Int, height: Int) throws {
        guard pixels.count == width * height else {
            throw InitializationError.mismatchedBufferSize(expected: pixels.count, actual: width * height)
        }
        
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    
    public init(pixelFormat: PixelFormat, components: [Pixel.Component], width: Int, height: Int) throws {
        var pixels: [Pixel] = []
        var pixelComponents = components
        
        while !pixelComponents.isEmpty {
            pixels.append(try pixelFormat.pixel(from: pixelComponents))
            pixelComponents.removeFirst(pixelFormat.componentsPerPixel)
        }
        
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    
}

// MARK: -

extension PixelBuffer {
    
    /// Describes errors that can occur when initializing a pixel buffer.
    public enum InitializationError: Error, CustomStringConvertible {
        
        /// Indicates that number of pixel buffer components does not match the
        /// total dimensions specified.
        ///
        /// - Parameters:
        ///   - expected: The expected number of individual pixels, equal to the
        ///   size of the pixels collection.
        ///   - actual: The provided total dimensions of the buffer, equal to
        ///   the product of the width and height provided in the initializer.
        ///
        case mismatchedBufferSize(expected: Int, actual: Int)
        
        // See `CustomStringConvertible`.
        public var description: String {
            switch self {
            case let .mismatchedBufferSize(expected, actual):
                return """
                The total number of pixels specified (\(expected)) \
                does not match the product of the dimensions specified \
                (\(actual)).
                """
            }
        }
        
    }
    
}
