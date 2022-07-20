import Foundation

/// Represents a pixel data type backed by components of any fixed-width integer
/// type.
///
/// `Pixel` is intended to represent the data stored by a pixel of an arbitrary
/// pixel format. A pixel can store any number of components, each of which is
/// backed by any fixed-width integer type (e.g., `UInt8` or `Int16`).
///
public struct Pixel {
    
    // MARK: -
    
    /// A sub-type of `Pixel` that represents a single color channel.
    ///
    /// Pixel components are represented as an enumeration of the possible
    /// color channels (including alpha). The associated value stored with each
    /// channel is an integer representation of that color's value.
    ///
    public enum Component {
        
        /// A red pixel component.
        ///
        /// - Parameter value: The integer value of the red color channel.
        ///
        case red(_ value: any FixedWidthInteger)
        
        /// A green pixel component.
        ///
        /// - Parameter value: The integer value of the green color channel.
        ///
        case green(_ value: any FixedWidthInteger)
        
        /// A blue pixel component.
        ///
        /// - Parameter value: The integer value of the blue color channel.
        ///
        case blue(_ value: any FixedWidthInteger)
        
        /// An alpha pixel component.
        ///
        /// - Parameter value: The integer value of the alpha color channel.
        ///
        case alpha(_ value: any FixedWidthInteger)
        
        // MARK: Properties
        
        /// The integer value of the component, regardless of which channel it
        /// represents.
        var value: any FixedWidthInteger {
            switch self {
            case
                let .red(value),
                let .green(value),
                let .blue(value),
                let .alpha(value):
                return value
            }
        }
        
    }
    
    // MARK: -
    
    // MARK: Properties

    /// The ordered components that constitute the pixel.
    let components: [Component]
    
    /// The total bit depth of the pixel as a computed sum of each component's
    /// bit width.
    public var bitDepth: Int { self.components.reduce(0, { $0 + $1.value.bitWidth }) }
    
    // MARK: - Initialization
    
    /// Creates a new pixel from an array of components.
    ///
    /// - Parameter components: The ordered pixel components.
    ///
    public init(components: [Component]) {
        self.components = components
    }
    
    /// Creates a new pixel from a common set of color components.
    ///
    /// - Parameters:
    ///   - red: An integer representation of the red color channel.
    ///   - green: An integer representation of the green color channel.
    ///   - blue: An integer representation of the blue color channel.
    ///   - alpha: An integer representation of the alpha color channel.
    ///
    public init(
        red: (any FixedWidthInteger)? = nil,
        green: (any FixedWidthInteger)? = nil,
        blue: (any FixedWidthInteger)? = nil,
        alpha: (any FixedWidthInteger)? = nil
    ) {
        self.components = [
            red.map { Component.red($0) },
            green.map { Component.green($0) },
            blue.map { Component.blue($0) },
            alpha.map { Component.alpha($0) }
        ].compactMap { $0 }
    }
    
}

// MARK: -

/// An 2D arrangement of pixels that constitute a complete buffer of pixel data.
///
/// A pixel buffer stores an ordered collection of pixels as well as the width
/// and height of the buffer. Together, this data describes a complete buffer of
/// pixel data, commonly used to represent an image.
///
public struct PixelBuffer {
    
    // MARK: Properties
    
    /// The individual pixels that comprise the total buffer.
    let pixels: [Pixel]
    
    /// The width of the buffer. Along with `height`, the product of these
    /// values must match the total count of `pixels`.
    let width: Int
    
    /// The height of the buffer. Along with `width`, the product of these
    /// values must match the total count of `pixels`.
    let height: Int
    
    // MARK: Initialization
    
    /// Creates a new pixel buffer.
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
    
}

// MARK: -

extension Collection where Element == Pixel.Component {
    
    /// Returns the first red component in a collection if it exists.
    var firstRed: Element? { self.first(where: { if case .red = $0 { return true } else { return false } }) }
    
    /// Returns the first greeb component in a collection if it exists.
    var firstGreen: Element? { self.first(where: { if case .green = $0 { return true } else { return false } }) }
    
    /// Returns the first blue component in a collection if it exists.
    var firstBlue: Element? { self.first(where: { if case .blue = $0 { return true } else { return false } }) }
    
    /// Returns the first alpha component in a collection if it exists.
    var firstAlpha: Element? { self.first(where: { if case .alpha = $0 { return true } else { return false } }) }
    
}

// MARK: -

extension Pixel.Component {
    
    /// Normalizes the value of the color component within the decimal range
    /// [0.0, 1.0].
    var normalizedValue: Float {
        let maxValue = type(of: self.value).max
        return Float(self.value) / Float(maxValue)
    }
    
}

// MARK: -

extension PixelBuffer {
    
    /// Describes errors that can occur when initializing a pixel buffer.
    enum InitializationError: Error, CustomStringConvertible {
        
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
        var description: String {
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
