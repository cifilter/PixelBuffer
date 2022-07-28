import Foundation

// MARK: Types
// MARK: -

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

// MARK: -

extension PixelFormat {
    
    /// The channels needed to define an interleaved pixel format.
    public struct Interleaved {
        
        // MARK: Properties
        
        /// The ordered collection of channels that comprise this format.
        public let channels: [Pixel.Channel]
        
        // MARK: Initialization
        
        /// Creates a new interleaved pixel format.
        ///
        /// - Parameter channels: The pixel channels that define an interleaved
        /// format.
        ///
        public init(channels: [Pixel.Channel]) {
            self.channels = channels
        }
        
        /// Creates a new interleaved pixel format from shorthand notation.
        ///
        /// Pixel format nanes are often abbreviated using shorthand to indicate
        /// which channels are involved, the data primitive used, and the number
        /// of bits each component or pixel will use. For example, "rgba8Uint"
        /// or "a32Float". This initializer creates a new interleaved format
        /// using a similar shorthand while still remaining statically typed.
        ///
        /// - Parameters:
        ///   - channelShorthands: The shorthand names for the channels to be
        ///   created.
        ///   - bpc: The number of bits per component, which is the bit width of
        ///   each channel created.
        ///   - formShorthand: The shorthand name for the binary form to be
        ///   used.
        ///
        public init(_ channelShorthands: [Self.ChannelShorthand], _ bpc: UInt, _ formShorthand: Self.FormShorthand) {
            let binaryForm: Pixel.Channel.BinaryForm
            
            switch formShorthand {
            case .uint: binaryForm = .unsignedInteger(bitWidth: bpc)
            case .sint: binaryForm = .signedInteger(bitWidth: bpc)
            case .float: binaryForm = .floatingPoint(bitWidth: bpc)
            }
            
            var channels: [Pixel.Channel] = []
            
            
            for channelShorthand in channelShorthands {
                let channelName: Pixel.Channel.Name
                
                switch channelShorthand {
                case .r: channelName = .red
                case .g: channelName = .green
                case .b: channelName = .blue
                case .a: channelName = .alpha
                }
                
                channels.append(.init(name: channelName, binaryForm: binaryForm))
            }
            
            self.init(channels: channels)
        }
        
    }
    
}

// MARK: -

extension PixelFormat {
    
    /// The channels needed to define a planar pixel format.
    public struct Planar {
        
    }
    
}

// MARK: -
// MARK: Extensions
// MARK: -

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

// MARK: -

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

// MARK: -

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

// MARK: -

extension PixelFormat.Interleaved {
    
    /// Shorthand notation for pixel channel names.
    ///
    /// These are used by the shorthand interleaved pixel format initializer.
    ///
    /// - SeeAlso: `init(channelShorthands:formShorthands:bpc:)`
    ///
    public enum ChannelShorthand {
        
        /// Shorthand notation for the red color channel.
        case r
        /// Shorthand notation for the green color channel.
        case g
        /// Shorthand notation for the blue color channel.
        case b
        /// Shorthand notation for the alpha channel.
        case a
        
    }
    
    /// Shorthand notation for pixel channel binary form type.
    ///
    /// These are used by the shorthand interleaved pixel format initializer.
    ///
    /// - SeeAlso: `init(channelShorthands:formShorthands:bpc:)`
    ///
    public enum FormShorthand {
        
        /// Shorthand notation for unsigned integer.
        case uint
        /// Shorthand notation for signed integer.
        case sint
        /// Shorthand notation for floating point.
        case float
        
    }
    
}
