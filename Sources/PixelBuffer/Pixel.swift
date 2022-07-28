import Foundation

// MARK: Types
// MARK: -

/// Represents a pixel data type backed by components of any numeric type.
///
/// `Pixel` is intended to represent the data stored by a pixel of an arbitrary
/// pixel format. A pixel can store any number of components, each of which is
/// backed by any numeric type (e.g., `UInt8` or `Float32`).
///
/// A pixel is composed of components, each of which is composed of a channel
/// and a value. A channel contains the specific information needed to identify
/// and properly represent a component's value in binary form.
///
public struct Pixel {
    
    // MARK: Properties

    /// The ordered components that constitute the pixel.
    public let components: [Component]
    
    /// The total bit depth of the pixel as a computed sum of each component's
    /// bit width.
    public var bitDepth: UInt { self.components.reduce(0, { $0 + $1.channel.bitWidth }) }
    
    // MARK: Initialization
    
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
    ///   - red: An unsigned integer representing the red color channel.
    ///   - green: An unsigned integer representing the green color channel.
    ///   - blue: An unsigned integer representing the blue color channel.
    ///   - alpha: An unsigned integer representing the alpha channel.
    ///
    public init(
        red: (some UnsignedInteger)? = nil,
        green: (some UnsignedInteger)? = nil,
        blue: (some UnsignedInteger)? = nil,
        alpha: (some UnsignedInteger)? = nil
    ) {
        self.components = [
            red.map { Component(channel: Channel.rUint(UInt($0.bitWidth)), value: $0) },
            green.map { Component(channel: Channel.gUint(UInt($0.bitWidth)), value: $0) },
            blue.map { Component(channel: Channel.bUint(UInt($0.bitWidth)), value: $0) },
            alpha.map { Component(channel: Channel.aUint(UInt($0.bitWidth)), value: $0) },
        ].compactMap { $0 }
    }
    
}

// MARK: -

extension Pixel {
    
    /// Defines the properties of a pixel channel.
    ///
    /// A channel is a descriptor of a single pixel component. The channel
    /// itself does not contain any values, but it describes the channel's
    /// name and what data type (binary form) is appropriate to store the raw
    /// value of the component represented by this channel.
    ///
    /// - SeeAlso: `Pixel.Component`
    ///
    public struct Channel {
        
        // MARK: Properties
        
        /// The name of this channel.
        public let name: Name
        /// The desired binary form for this channel.
        public let binaryForm: BinaryForm
        
        /// The bit width of this channel's binary form.
        public var bitWidth: UInt { self.binaryForm.bitWidth }
        /// The resolved numeric storage type to be used by this channel.
        public var storageType: any Numeric.Type { self.binaryForm.storageType }
        
        // MARK: Initialization
        
        /// Creates a new pixel channel.
        ///
        /// - Parameters:
        ///   - name: The name of this pixel channel.
        ///   - binaryForm: The binary form of this pixel channel.
        ///
        public init(name: Name, binaryForm: BinaryForm) {
            self.name = name
            self.binaryForm = binaryForm
        }

    }
    
}

// MARK: -

extension Pixel {
    
    /// A pixel component contains an abstract channel description as well as a
    /// concrete data value. A component's channel determines how the component
    /// is identified (e.g., a red or blue component) and represented in binary
    /// form (e.g., a signed, 16-bit integer or a 32-bit floating point).
    ///
    /// - SeeAlso: `Pixel.Channel`
    ///
    public struct Component {
        
        // MARK: Properties
        
        /// The channel that describes this component.
        public let channel: Channel
        /// The actual value of this component.
        public let value: any Numeric
        
        // MARK: Initialization
        
        /// Creates a new pixel component.
        ///
        /// - Parameters:
        ///   - channel: The channel associated with this component.
        ///   - value: The pixel value of this component.
        ///
        public init(channel: Channel, value: some Numeric) {
            self.channel = channel
            self.value = value
            
            // TODO (SP): Coerce the provided value into the resolved storage
            // type determined by the channel.
        }
        
    }
    
}

// MARK: -

extension Pixel.Channel {
    
    /// The name of the channel.
    public enum Name {
        
        // Interleaved format channels
        
        /// Identifies a red color channel.
        case red
        /// Identifies a blue color channel.
        case blue
        /// Identifies a green color channel.
        case green
        /// Identifies an alpha channel.
        case alpha
        
        // Planar format channels
        
        /// Identifies a luminance channel.
        case luminance
        /// Identifies a blue chrominance channel.
        case chrominanceBlue
        /// Identifies a red chrominance channel.
        case chrominanceRed
        
    }
    
}

// MARK: -

extension Pixel.Channel {
    
    /// The binary form that values stored using this channel should take.
    ///
    /// The binary form of a channel is determined by the desired data
    /// primitive and the bit width. From this, a specific numeric type is
    /// chosen for this pixel channel.
    ///
    /// - Note: Specifying a bit width of 0 **or** greater than the maximum
    /// available bit width for a given primitive will result in the
    /// primitive with the largest available storage (i.e., bit width) being
    /// used.
    ///
    public enum BinaryForm {
        
        /// Indicates that an unsigned integer type should back this
        /// channel.
        ///
        /// - Parameter bitWidth: The maximum number of bits needed to
        /// represent component values with this channel.
        case unsignedInteger(bitWidth: UInt)
        
        /// Indicates that a signed integer type should back this channel.
        ///
        /// - Parameter bitWidth: The maximum number of bits needed to
        /// represent component values with this channel.
        case signedInteger(bitWidth: UInt)
        
        /// Indicates that a floating point type should back this channel.
        ///
        /// - Parameter bitWidth: The maximum number of bits needed to
        /// represent component values with this channel.
        case floatingPoint(bitWidth: UInt)
        
    }
    
}

// MARK: -
// MARK: Extensions
// MARK: -

extension Collection where Element == Pixel.Component {
    
    /// Returns the first red component in a collection if it exists.
    var firstRed: Element? { self.first(where: { if case .red = $0.channel.name { return true } else { return false } }) }
    
    /// Returns the first greeb component in a collection if it exists.
    var firstGreen: Element? { self.first(where: { if case .green = $0.channel.name { return true } else { return false } }) }
    
    /// Returns the first blue component in a collection if it exists.
    var firstBlue: Element? { self.first(where: { if case .blue = $0.channel.name { return true } else { return false } }) }
    
    /// Returns the first alpha component in a collection if it exists.
    var firstAlpha: Element? { self.first(where: { if case .alpha = $0.channel.name { return true } else { return false } }) }
    
}

// MARK: -

extension Pixel.Component {
    
    /// Normalizes the value of the color component within the decimal range
    /// [0.0, 1.0].
    public var normalizedValue: Float {
        let floatValue: Float
        let maxValue: Float
        
        // NB: Float(type(of: value).<type property>) causes a compilation
        // error, but pulling out the value first does not.
        if let value = self.value as? any FixedWidthInteger {
            floatValue = Float(value)
            let maxIntValue = type(of: value).max
            maxValue = Float(maxIntValue)
        } else if let value = self.value as? any BinaryFloatingPoint {
            floatValue = Float(value)
            let greatestFiniteMagnitude = type(of: value).greatestFiniteMagnitude
            maxValue = Float(greatestFiniteMagnitude)
        } else {
            floatValue = 0.0
            maxValue = 1.0
        }
        
        return floatValue / maxValue
    }
    
}

// MARK: -

extension Pixel.Channel {
    
    // MARK: Common Channel Types
    
    /// Creates an unsigned integer red channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func rUint(_ bitWidth: UInt) -> Self {
        return self.init(name: .red, binaryForm: .unsignedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a signed integer red channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func rSint(_ bitWidth: UInt) -> Self {
        return self.init(name: .red, binaryForm: .signedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a floating point red channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func rFloat(_ bitWidth: UInt) -> Self {
        return self.init(name: .red, binaryForm: .floatingPoint(bitWidth: bitWidth))
    }
    
    /// Creates an unsigned integer green channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func gUint(_ bitWidth: UInt) -> Self {
        return self.init(name: .green, binaryForm: .unsignedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a signed integer green channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func gSint(_ bitWidth: UInt) -> Self {
        return self.init(name: .green, binaryForm: .signedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a floating point green channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func gFloat(_ bitWidth: UInt) -> Self {
        return self.init(name: .green, binaryForm: .floatingPoint(bitWidth: bitWidth))
    }
    
    /// Creates a unsigned integer blue channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func bUint(_ bitWidth: UInt) -> Self {
        return self.init(name: .blue, binaryForm: .unsignedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a signed integer blue channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func bSint(_ bitWidth: UInt) -> Self {
        return self.init(name: .blue, binaryForm: .signedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a floating point blue channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func bFloat(_ bitWidth: UInt) -> Self {
        return self.init(name: .blue, binaryForm: .floatingPoint(bitWidth: bitWidth))
    }
    
    /// Creates an unsigned integer alpha channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func aUint(_ bitWidth: UInt) -> Self {
        return self.init(name: .alpha, binaryForm: .unsignedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a signed integer alpha channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func aSint(_ bitWidth: UInt) -> Self {
        return self.init(name: .alpha, binaryForm: .signedInteger(bitWidth: bitWidth))
    }
    
    /// Creates a floating point alpha channel.
    ///
    /// - Parameter bitWidth: The bit width of this channel.
    ///
    /// - Returns: A new channel with the designed bit width.
    ///
    public static func aFloat(_ bitWidth: UInt) -> Self {
        return self.init(name: .alpha, binaryForm: .floatingPoint(bitWidth: bitWidth))
    }
    
    /// A common, 8-bit unsigned integer red channel.
    public static let r8Uint: Self = Self.rUint(8)
    /// A common, 8-bit unsigned integer green channel.
    public static let g8Uint: Self = Self.gUint(8)
    /// A common, 8-bit unsigned integer blue channel.
    public static let b8Uint: Self = Self.bUint(8)
    /// A common, 8-bit unsigned integer alpha channel.
    public static let a8Uint: Self = Self.aUint(8)
    
    /// A common, 8-bit signed integer red channel.
    public static let r8Sint: Self = Self.rSint(8)
    /// A common, 8-bit signed integer green channel.
    public static let g8Sint: Self = Self.gSint(8)
    /// A common, 8-bit signed integer blue channel.
    public static let b8Sint: Self = Self.bSint(8)
    /// A common, 8-bit signed integer alpha channel.
    public static let a8Sint: Self = Self.aSint(8)
    
    /// A common, 16-bit floating point red channel.
    public static let r16Float: Self = Self.rFloat(16)
    /// A common, 16-bit floating point green channel.
    public static let g16Float: Self = Self.gFloat(16)
    /// A common, 16-bit floating point blue channel.
    public static let b16Float: Self = Self.bFloat(16)
    /// A common, 16-bit floating point alpha channel.
    public static let a16Float: Self = Self.aFloat(16)
    
}

// MARK: -

extension Pixel.Channel.BinaryForm {
    
    /// The number of bits a channel should use to specify component values.
    ///
    /// By specifying specific bit widths for a given channel, a pixel can be
    /// represented by any arrangement of channels using any number of bits.
    /// This allows channels to fully represent ordinary pixel formats (e.g.,
    /// an RGBA format where each component is stored as an 8-bit unsigned
    /// integer) and packed pixel formats (e.g., an RGBA format where the RGB
    /// components are stored using 8 bits of a 16-bit unsigned integer, and the
    /// remaining bit stores the A component).
    ///
    /// - Note: Currently, `BinaryForm` merely represents the desired bit layout
    /// for the storage of component values. However, `Pixel.Component.value` is
    /// stored as any `Numeric` value, so the in-memory representation of a
    /// pixel's components is not highly optimized.
    ///
    /// - SeeAlso: `storageType`
    ///
    public var bitWidth: UInt {
        switch self {
        case
            let .unsignedInteger(bitWidth),
            let .signedInteger(bitWidth),
            let .floatingPoint(bitWidth):
            return bitWidth
        }
    }
    
    /// The platform storage type that best matches a channel's binary form.
    ///
    /// For all forms, the smallest type that can represent all possible
    /// component values is selected. In other words, for a channel's given bit
    /// width, the smallest type whose bit width is *at least* as large as the
    /// channel's is chosen.
    ///
    /// - Note: If an invalid bit width is specified for this binary form (i.e.,
    /// 0 or a value greater than the largest type's bit width), then the
    /// largest available type is used.
    ///
    /// - SeeAlso: `bitWidth`
    ///
    public var storageType: any Numeric.Type {
        switch self {
        case let .unsignedInteger(bitWidth):
            let types: [any FixedWidthInteger.Type] = [UInt8.self, UInt16.self, UInt32.self, UInt64.self]
            return types.first(where: { $0.bitWidth >= bitWidth }) ?? UInt64.self
        case let .signedInteger(bitWidth):
            let types: [any FixedWidthInteger.Type] = [Int8.self, Int16.self, Int32.self, Int64.self]
            return types.first(where: { $0.bitWidth >= bitWidth }) ?? Int64.self
        case let .floatingPoint(bitWidth):
            switch bitWidth {
            case 1...16: return Float16.self
            case 17...32: return Float32.self
            case 33...64: return Float64.self
            default: return Float64.self
            }
        }
    }
    
}
