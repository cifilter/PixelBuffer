import Foundation

/// A pixel format describes the arrangement of color data that represents a
/// single pixel.
public enum PixelFormat {
    
    /// Indicates that pixel component values are interleaved.
    ///
    /// Interleaved pixel formats are those where each pixel component's values
    /// are provided in sequence. After reading all the component values in
    /// order, a full pixel buffer has been specified.
    ///
    /// - Parameter subformat: The specific interleaved subformat that describes
    /// a pixel.
    ///
    case interleaved(_ subformat: PixelFormat.Interleaved)
    
    /// Indicates that pixel component values are stored in separate planes.
    ///
    /// Planar pixel formats are those where a pixel buffer's components are
    /// separated into multiple planes. Each plane contains a sequence of values
    /// that are needed to construct a "slice" of a pixel buffer. Only after
    /// reading values from all planes can a complete pixel buffer be created.
    ///
    /// For example, a commonly used planar format separates a pixel buffer into
    /// a luminance (brightness) plane and a chrominance (color) plane.
    /// Separately, these planes don't describe a full image, but when their
    /// values are combined in a particular way, the result is a standard image
    /// that could be then described as an interleaved pixel buffer.
    ///
    /// - Parameter subformat: The specific planar subformat that describes a
    /// pixel.
    ///
    case planar(_ subformat: PixelFormat.Planar)
    
    /// The pixel format is undefined.
    ///
    /// If a pixel is manually created using raw color components, then each
    /// pixel might arbitrarily have its own "format" at that point. Therefore,
    /// the pixel buffer itself does not have a defined format.
    ///
    case undefined
    
}

extension PixelFormat {
    
    // MARK: -
    
    /// The channels needed to define an interleaved pixel format.
    public struct Interleaved {
        
        /// The ordered collection of channels that comprise this format.
        public let channels: [Pixel.Channel]
        
    }
    
    /// The channels needed to define a planar pixel format.
    public struct Planar {
        
    }
    
}

extension PixelFormat.Interleaved {
    
    // Common formats
    
    public static let a8Unorm: Self = Self.init(channels: [.a8Uint])
    public static let r8Unorm: Self = Self.init(channels: [.r8Uint])
    public static let r8Unorm_srgb: Self = Self.init(channels: [.r8Uint])
    public static let r8Snorm: Self = Self.init(channels: [.r8Sint])
    public static let r8Uint: Self = Self.init(channels: [.r8Uint])
    public static let r8Sint: Self = Self.init(channels: [.r8Sint])
    
    public static let r16Unorm: Self = Self.init(channels: [.rUint(16)])
    public static let r16Snorm: Self = Self.init(channels: [.rSint(16)])
    public static let r16Uint: Self = Self.init(channels: [.rUint(16)])
    public static let r16Sint: Self = Self.init(channels: [.rSint(16)])
    public static let r16Float: Self = Self.init(channels: [.r16Float])
    public static let rg8Unorm: Self = Self.init(channels: [.r8Uint, .g8Uint])
    public static let rg8Unorm_srgb: Self = Self.init(channels: [.r8Uint, .g8Uint])
    public static let rg8Snorm: Self = Self.init(channels: [.r8Sint, .g8Sint])
    public static let rg8Uint: Self = Self.init(channels: [.r8Uint, .g8Uint])
    public static let rg8Sint: Self = Self.init(channels: [.r8Sint, .g8Sint])
    
    public static let b5g6r5Unorm: Self = Self.init(channels: [.bUint(5), .gUint(6), .rUint(5)])
    public static let a1bgr5Unorm: Self = Self.init(channels: [.aUint(1), .bUint(5), .gUint(5), .rUint(5)])
    public static let abgr4Unorm: Self = Self.init(channels: [.aUint(4), .bUint(4), .gUint(4), .rUint(4)])
    public static let bgr5a1Unorm: Self = Self.init(channels: [.bUint(5), .gUint(5), .rUint(5), .aUint(1)])
    
    public static let r32Uint: Self = Self.init(channels: [.rUint(32)])
    public static let r32Sint: Self = Self.init(channels: [.rSint(32)])
    public static let r32Float: Self = Self.init(channels: [.rFloat(32)])
    public static let rg16Unorm: Self = Self.init(channels: [.rUint(16), .gUint(16)])
    public static let rg16Snorm: Self = Self.init(channels: [.rSint(16), .gSint(16)])
    public static let rg16Uint: Self = Self.init(channels: [.rUint(16), .gUint(16)])
    public static let rg16Sint: Self = Self.init(channels: [.rSint(16), .gSint(16)])
    public static let rg16Float: Self = Self.init(channels: [.r16Float, .g16Float])
    
    public static let rgba8Unorm: Self = Self.init(channels: [.r8Uint, .g8Uint, .b8Uint, .a8Uint])
    public static let rgba8Unorm_srgb: Self = Self.init(channels: [.r8Uint, .g8Uint, .b8Uint, .a8Uint])
    public static let rgba8Snorm: Self = Self.init(channels: [.r8Sint, .g8Sint, .b8Sint, .a8Sint])
    public static let rgba8Uint: Self = Self.init(channels: [.r8Uint, .g8Uint, .b8Uint, .a8Uint])
    public static let rgba8Sint: Self = Self.init(channels: [.r8Sint, .g8Sint, .b8Sint, .a8Sint])
    public static let bgra8Unorm: Self = Self.init(channels: [.b8Uint, .g8Uint, .r8Uint, .a8Uint])
    public static let bgra8Unorm_srgb: Self = Self.init(channels: [.b8Sint, .g8Sint, .r8Sint, .a8Sint])
    
    public static let bgr10a2Unorm: Self = Self.init(channels: [.bUint(10), .gUint(10), .rUint(10), .aUint(2)])
    public static let rgb10a2Unorm: Self = Self.init(channels: [.rUint(10), .gUint(10), .bUint(10), .aUint(2)])
    public static let rgb10a2Uint: Self = Self.init(channels: [.rUint(10), .gUint(10), .bUint(10), .aUint(2)])
    public static let rg11b10Float: Self = Self.init(channels: [.rFloat(11), .gFloat(11), .bFloat(10)])
//    public static let rgb9e5Float  ???
    
    public static let rg32Uint: Self = Self.init(channels: [.rUint(32), .gUint(32)])
    public static let rg32Sint: Self = Self.init(channels: [.rSint(32), .gSint(32)])
    public static let rg32Float: Self = Self.init(channels: [.rFloat(32), .gFloat(32)])
    public static let rgba16Unorm: Self = Self.init(channels: [.rUint(16), .gUint(16), .bUint(16), .aUint(16)])
    public static let rgba16Snorm: Self = Self.init(channels: [.rSint(16), .gSint(16), .bSint(16), .aSint(16)])
    public static let rgba16Uint: Self = Self.init(channels: [.rUint(16), .gUint(16), .bUint(16), .aUint(16)])
    public static let rgba16Sint: Self = Self.init(channels: [.rSint(16), .gSint(16), .bSint(16), .aSint(16)])
    public static let rgba16Float: Self = Self.init(channels: [.r16Float, .g16Float, .b16Float, .a16Float])
    
    public static let rgba32Uint: Self = Self.init(channels: [.rUint(32), .gUint(32), .bUint(32), .aUint(32)])
    public static let rgba32Sint: Self = Self.init(channels: [.rSint(32), .gSint(32), .bSint(32), .aSint(32)])
    public static let rgba32Float: Self = Self.init(channels: [.rFloat(32), .gFloat(32), .bFloat(32), .aFloat(32)])
    
//    // One component
//    public static func r(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc)]) }
//
//    // Two components
//    public static func rg(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .gUint(bpc)]) }
//    public static func gb(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .rUint(bpc)]) }
//
//    // Three components
//    public static func rgb(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .gUint(bpc), .bUint(bpc)]) }
//    public static func rbg(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .bUint(bpc), .gUint(bpc)]) }
//
//    public static func grb(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .rUint(bpc), .bUint(bpc)]) }
//    public static func gbr(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .bUint(bpc), .rUint(bpc)]) }
//
//    public static func brg(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .rUint(bpc), .gUint(bpc)]) }
//    public static func bgr(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .gUint(bpc), .rUint(bpc)]) }
//
//    // Four components
//    public static func rgba(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .gUint(bpc), .bUint(bpc), .aUint(bpc)]) }
//    public static func rgab(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .gUint(bpc), .aUint(bpc), .bUint(bpc)]) }
//    public static func rbga(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .bUint(bpc), .gUint(bpc), .aUint(bpc)]) }
//    public static func rbag(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .bUint(bpc), .aUint(bpc), .gUint(bpc)]) }
//    public static func ragb(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .aUint(bpc), .gUint(bpc), .bUint(bpc)]) }
//    public static func rabg(bpc: UInt) -> Self { self.init(channels: [.rUint(bpc), .aUint(bpc), .bUint(bpc), .gUint(bpc)]) }
//
//    public static func grba(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .rUint(bpc), .bUint(bpc), .aUint(bpc)]) }
//    public static func grab(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .rUint(bpc), .aUint(bpc), .bUint(bpc)]) }
//    public static func gbra(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .bUint(bpc), .rUint(bpc), .aUint(bpc)]) }
//    public static func gbar(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .bUint(bpc), .aUint(bpc), .rUint(bpc)]) }
//    public static func garb(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .aUint(bpc), .rUint(bpc), .bUint(bpc)]) }
//    public static func gabr(bpc: UInt) -> Self { self.init(channels: [.gUint(bpc), .aUint(bpc), .bUint(bpc), .rUint(bpc)]) }
//
//    public static func brga(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .rUint(bpc), .gUint(bpc), .aUint(bpc)]) }
//    public static func brag(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .rUint(bpc), .aUint(bpc), .gUint(bpc)]) }
//    public static func bgra(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .gUint(bpc), .rUint(bpc), .aUint(bpc)]) }
//    public static func bgar(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .gUint(bpc), .aUint(bpc), .rUint(bpc)]) }
//    public static func barg(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .aUint(bpc), .rUint(bpc), .gUint(bpc)]) }
//    public static func bagr(bpc: UInt) -> Self { self.init(channels: [.bUint(bpc), .aUint(bpc), .gUint(bpc), .rUint(bpc)]) }
    
}

extension PixelFormat {
    
    /// The number of components each pixel of this format contains.
    public var componentsPerPixel: Int {
        switch self {
        case let .interleaved(subformat): return subformat.channels.count
        case .planar: return 0
        case .undefined: return 0
        }
    }
    
}

extension PixelFormat {
    
    /// Creates a new pixel from a collection of components.
    ///
    /// If the number of components provided is not *at least* as many as the
    /// format requires, then an error is thrown. Any components beyond the
    /// number required are ignored.
    ///
    /// - Parameter components: The pixel components from which this format can
    /// create a new pixel
    ///
    /// - Returns: A new pixel that matches this format.
    ///
    public func pixel(from components: [Pixel.Component]) throws -> Pixel {
        guard components.count >= self.componentsPerPixel else {
            throw InitializationError.insufficientComponents(expected: self.componentsPerPixel, actual: components.count)
        }
        
        return .init(components: Array(components.prefix(self.componentsPerPixel)))
    }
    
}

extension PixelFormat {
    
    /// Describes errors that can occur when initializing a pixel from a pixel
    /// format.
    public enum InitializationError: Error, CustomStringConvertible {
        
        /// Indicates that there are too few pixel components to create a pixel
        /// for the given pixel format.
        ///
        /// - Parameters:
        ///   - expected: The number of components needed for the pixel format
        ///   to create a new pixel.
        ///   - actual: The number of provided components, which is less than
        ///   the number needed.
        ///
        case insufficientComponents(expected: Int, actual: Int)
        
        // See `CustomStringConvertible`.
        public var description: String {
            switch self {
            case let .insufficientComponents(expected, actual):
                // TODO (SP): Create string description of `PixelFormat`.
                return """
                The total number of pixel components (\(actual)) is less than \
                the number of components required by the pixel format \
                (\(expected)).
                """
            }
        }
        
    }
    
}
