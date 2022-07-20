import Foundation

public struct Pixel {
    
    public enum Component {
        
        var value: any FixedWidthInteger {
            switch self {
            case let .red(value), let .green(value), let .blue(value), let .alpha(value): return value
            }
        }
        
        case red(_ value: any FixedWidthInteger)
        case green(_ value: any FixedWidthInteger)
        case blue(_ value: any FixedWidthInteger)
        case alpha(_ value: any FixedWidthInteger)
        
    }

    let components: [Component]
    var bitDepth: Int { self.components.reduce(0, { $0 + $1.value.bitWidth }) }
    
    public init(components: [Component]) {
        self.components = components
    }
    
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

public struct PixelBuffer {
    
    public let pixels: [Pixel]
    public let width: Int
    public let height: Int
    
    public init(pixels: [Pixel], width: Int, height: Int) throws {
        guard pixels.count == width * height else {
            throw InitializationError.mismatchedBufferSize(expected: pixels.count, actual: width * height)
        }
        
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    
}

extension Collection where Element == Pixel.Component {
    
    var firstRed: Element? { self.first(where: { if case .red = $0 { return true } else { return false } }) }
    var firstGreen: Element? { self.first(where: { if case .green = $0 { return true } else { return false } }) }
    var firstBlue: Element? { self.first(where: { if case .blue = $0 { return true } else { return false } }) }
    var firstAlpha: Element? { self.first(where: { if case .alpha = $0 { return true } else { return false } }) }
    
}

extension Pixel.Component {
    
    var normalizedValue: Float {
        let maxValue = type(of: self.value).max
        return Float(self.value) / Float(maxValue)
    }
    
}

extension PixelBuffer {
    
    enum InitializationError: Error {
        
        case mismatchedBufferSize(expected: Int, actual: Int)
        
    }
    
}
