#if canImport(CoreImage)

import Foundation
import CoreImage

extension PixelFormat {
    
    /// An uninhabited type used to contain pixel format declarations that match
    /// Core Image's own pixel formats.
    enum CoreImage {
        
        public static let argb8: PixelFormat = .interleaved(.init([.a, .r, .g, .b], 8, .uint))
        public static let bgra8: PixelFormat = .interleaved(.init([.b, .g, .r, .a], 8, .uint))
        public static let rgba8: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 8, .uint))
        public static let abgr8: PixelFormat = .interleaved(.init([.a, .b, .g, .r], 8, .uint))
        
        public static let rgbaHalf: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .float))
        public static let rgba16: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 16, .uint))
        public static let rgbaFloat: PixelFormat = .interleaved(.init([.r, .g, .b, .a], 32, .float))
        
        public static let a8: PixelFormat = .interleaved(.init([.a], 8, .uint))
        public static let a16: PixelFormat = .interleaved(.init([.a], 16, .uint))
        public static let aHalf: PixelFormat = .interleaved(.init([.a], 16, .float))
        public static let aFloat: PixelFormat = .interleaved(.init([.a], 32, .float))
        
        public static let r8: PixelFormat = .interleaved(.init([.r], 8, .uint))
        public static let r16: PixelFormat = .interleaved(.init([.r], 16, .uint))
        public static let rHalf: PixelFormat = .interleaved(.init([.r], 16, .float))
        public static let rFloat: PixelFormat = .interleaved(.init([.r], 32, .float))
        
        public static let rg8: PixelFormat = .interleaved(.init([.r, .g], 8, .uint))
        public static let rg16: PixelFormat = .interleaved(.init([.r, .g], 16, .uint))
        public static let rgHalf: PixelFormat = .interleaved(.init([.r, .g], 16, .float))
        public static let rgFloat: PixelFormat = .interleaved(.init([.r, .g], 32, .float))
        
//      Planar formats
//
//        CORE_IMAGE_EXPORT CIFormat kCIFormatL8 NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatL16 NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLh NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLf NS_AVAILABLE(10_12, 10_0);
//
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLA8 NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLA16 NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLAh NS_AVAILABLE(10_12, 10_0);
//        CORE_IMAGE_EXPORT CIFormat kCIFormatLAf NS_AVAILABLE(10_12, 10_0);
        
    }
}

extension CIFormat {
    
    /// Returns a compatible `PixelFormat`, if possible, from the current Core
    /// Image pixel format.
    public var pixelBufferFormat: PixelFormat {
        
        switch self {
        case .ARGB8: return .CoreImage.argb8
        case .BGRA8: return .CoreImage.bgra8
        case .RGBA8: return .CoreImage.rgba8
        case .ABGR8: return .CoreImage.abgr8
            
        case .RGBAh: return .CoreImage.rgbaHalf
        case .RGBA16: return .CoreImage.rgba16
        case .RGBAf: return .CoreImage.rgbaFloat
            
        case .A8: return .CoreImage.a8
        case .A16: return .CoreImage.a16
        case .Ah: return .CoreImage.aHalf
        case .Af: return .CoreImage.aFloat
            
        case .R8: return .CoreImage.r8
        case .R16: return .CoreImage.r16
        case .Rh: return .CoreImage.rHalf
        case .Rf: return .CoreImage.rFloat
            
        case .RG8: return .CoreImage.rg8
        case .RG16: return .CoreImage.rg16
        case .RGh: return .CoreImage.rgHalf
        case .RGf: return .CoreImage.rgFloat
            
        default: return .undefined
        }
        
    }
    
}

#endif
