#if canImport(Metal)

import Foundation
import Metal

extension PixelFormat {
    
    /// An uninhabited type used to contain pixel format declarations that match
    /// Metal's own pixel formats.
    enum Metal {
        
        public static let a8Unorm: PixelFormat = .interleaved(.init([.a], 8, .uint))
        public static let r8Unorm: PixelFormat = .interleaved(.init([.r], 8, .uint))
        public static let r8Unorm_srgb: PixelFormat = .interleaved(.init([.r], 8, .uint))
        public static let r8Snorm: PixelFormat = .interleaved(.init([.r], 8, .sint))
        public static let r8Uint: PixelFormat = .interleaved(.init([.r], 8, .uint))
        public static let r8Sint: PixelFormat = .interleaved(.init([.r], 8, .sint))
        
        public static let r16Unorm: PixelFormat = .interleaved(.init([.r], 16, .uint))
        public static let r16Snorm: PixelFormat = .interleaved(.init([.r], 16, .sint))
        public static let r16Uint: PixelFormat = .interleaved(.init([.r], 16, .uint))
        public static let r16Sint: PixelFormat = .interleaved(.init([.r], 16, .sint))
        public static let r16Float: PixelFormat = .interleaved(.init([.r], 16, .float))
        public static let rg8Unorm: PixelFormat = .interleaved(.init([.r ,.g], 8, .uint))
        public static let rg8Unorm_srgb: PixelFormat = .interleaved(.init([.r ,.g], 8, .uint))
        public static let rg8Snorm: PixelFormat = .interleaved(.init([.r ,.g], 8, .sint))
        public static let rg8Uint: PixelFormat = .interleaved(.init([.r ,.g], 8, .uint))
        public static let rg8Sint: PixelFormat = .interleaved(.init([.r ,.g], 8, .sint))
        
        public static let b5g6r5Unorm: PixelFormat = .interleaved(.init(channels: [.bUint(5), .gUint(6), .rUint(5)]))
        public static let a1bgr5Unorm: PixelFormat = .interleaved(.init(channels: [.aUint(1), .bUint(5), .gUint(5), .rUint(5)]))
        public static let abgr4Unorm: PixelFormat = .interleaved(.init([.a, .b, .g, .r], 8, .uint))
        public static let bgr5a1Unorm: PixelFormat = .interleaved(.init(channels: [.bUint(5), .gUint(5), .rUint(5), .aUint(1)]))
        
        public static let r32Uint: PixelFormat = .interleaved(.init([.r], 32, .uint))
        public static let r32Sint: PixelFormat = .interleaved(.init([.r], 32, .sint))
        public static let r32Float: PixelFormat = .interleaved(.init([.r], 32, .float))
        public static let rg16Unorm: PixelFormat = .interleaved(.init([.r, .g], 16, .uint))
        public static let rg16Snorm: PixelFormat = .interleaved(.init([.r, .g], 16, .sint))
        public static let rg16Uint: PixelFormat = .interleaved(.init([.r, .g], 16, .uint))
        public static let rg16Sint: PixelFormat = .interleaved(.init([.r, .g], 16, .sint))
        public static let rg16Float: PixelFormat = .interleaved(.init([.r, .g], 16, .float))
        
        public static let rgba8Unorm: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .uint))
        public static let rgba8Unorm_srgb: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .uint))
        public static let rgba8Snorm: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .sint))
        public static let rgba8Uint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .uint))
        public static let rgba8Sint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .sint))
        public static let bgra8Unorm: PixelFormat = .interleaved(.init([.b, .g, .r, .a], 8, .uint))
        public static let bgra8Unorm_srgb: PixelFormat = .interleaved(.init([.b, .g, .r, .a], 8, .uint))
        
        public static let bgr10a2Unorm: PixelFormat = .interleaved(.init(channels: [.bUint(10), .gUint(10), .rUint(10), .aUint(2)]))
        public static let rgb10a2Unorm: PixelFormat = .interleaved(.init(channels: [.rUint(10), .gUint(10), .bUint(10), .aUint(2)]))
        public static let rgb10a2Uint: PixelFormat = .interleaved(.init(channels: [.rUint(10), .gUint(10), .bUint(10), .aUint(2)]))
        public static let rg11b10Float: PixelFormat = .interleaved(.init(channels: [.rFloat(11), .gFloat(11), .bFloat(10)]))
        
        public static let rg32Uint: PixelFormat = .interleaved(.init([.r, .g], 32, .uint))
        public static let rg32Sint: PixelFormat = .interleaved(.init([.r, .g], 32, .sint))
        public static let rg32Float: PixelFormat = .interleaved(.init([.r, .g], 32, .float))
        public static let rgba16Unorm: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .uint))
        public static let rgba16Snorm: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .sint))
        public static let rgba16Uint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .uint))
        public static let rgba16Sint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .sint))
        public static let rgba16Float: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .float))
        
        public static let rgba32Uint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 32, .uint))
        public static let rgba32Sint: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 32, .sint))
        public static let rgba32Float: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 32, .float))
        
    }
}

extension MTLPixelFormat {
    
    /// Returns a compatible `PixelFormat`, if possible, from the current Metal
    /// pixel format.
    public var pixelBufferFormat: PixelFormat {
        switch self {
        case .a8Unorm: return .Metal.a8Unorm
        case .r8Unorm: return .Metal.r8Unorm
        case .r8Unorm_srgb: return .Metal.r8Unorm_srgb
        case .r8Snorm: return .Metal.r8Snorm
        case .r8Uint: return .Metal.r8Uint
        case .r8Sint: return .Metal.r8Sint
            
        case .r16Unorm: return .Metal.r16Unorm
        case .r16Snorm: return .Metal.r16Snorm
        case .r16Uint: return .Metal.r16Uint
        case .r16Sint: return .Metal.r16Sint
        case .r16Float: return .Metal.r16Float
        case .rg8Unorm: return .Metal.rg8Unorm
        case .rg8Unorm_srgb: return .Metal.rg8Unorm_srgb
        case .rg8Snorm: return .Metal.rg8Snorm
        case .rg8Uint: return .Metal.rg8Uint
        case .rg8Sint: return .Metal.rg8Sint
            
        case .b5g6r5Unorm: return .Metal.b5g6r5Unorm
        case .a1bgr5Unorm: return .Metal.a1bgr5Unorm
        case .abgr4Unorm: return .Metal.abgr4Unorm
        case .bgr5A1Unorm: return .Metal.bgr5a1Unorm
            
        case .r32Uint: return .Metal.r32Uint
        case .r32Sint: return .Metal.r32Sint
        case .r32Float: return .Metal.r32Float
        case .rg16Unorm: return .Metal.rg16Unorm
        case .rg16Snorm: return .Metal.rg16Snorm
        case .rg16Uint: return .Metal.rg16Uint
        case .rg16Sint: return .Metal.rg16Sint
        case .rg16Float: return .Metal.rg16Float
            
        case .rgba8Unorm: return .Metal.rgba8Unorm
        case .rgba8Unorm_srgb: return .Metal.rgba8Unorm_srgb
        case .rgba8Snorm: return .Metal.rgba8Snorm
        case .rgba8Uint: return .Metal.rgba8Uint
        case .rgba8Sint: return .Metal.rgba8Sint
        case .bgra8Unorm: return .Metal.bgra8Unorm
        case .bgra8Unorm_srgb: return .Metal.bgra8Unorm_srgb

        case .bgr10a2Unorm: return .Metal.bgr10a2Unorm
        case .rgb10a2Unorm: return .Metal.rgb10a2Unorm
        case .rgb10a2Uint: return .Metal.rgb10a2Uint
        case .rg11b10Float: return .Metal.rg11b10Float
            
        case .rg32Uint: return .Metal.rg32Uint
        case .rg32Sint: return .Metal.rg32Sint
        case .rg32Float: return .Metal.rg32Float
        case .rgba16Unorm: return .Metal.rgba16Unorm
        case .rgba16Snorm: return .Metal.rgba16Snorm
        case .rgba16Uint: return .Metal.rgba16Uint
        case .rgba16Sint: return .Metal.rgba16Sint
        case .rgba16Float: return .Metal.rgba16Float
            
        case .rgba32Uint: return .Metal.rgba32Uint
        case .rgba32Sint: return .Metal.rgba32Sint
        case .rgba32Float: return .Metal.rgba32Float
            
        default: return .undefined
        }
    }
    
}

#endif
