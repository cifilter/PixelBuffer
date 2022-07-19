import Foundation

public struct Pixel {

    let components: [Int]
    var bitDepth: Int { self.components.count * 8 }
    
    public init(components: [Int]) {
        self.components = components
    }
    
}

public struct PixelBuffer {
    
    public struct Size {
        let width: Int
        let height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
    
    public let pixels: [Pixel]
    public let size: Size
    
    public init(pixels: [Pixel], size: Size) throws {
        try self.init(pixels: pixels, width: size.width, height: size.height)
    }
    
    public init(pixels: [Pixel], width: Int, height: Int) throws {
        guard pixels.count == width * height else {
            throw InitializationError.mismatchedBufferSize(expected: pixels.count, actual: width * height)
        }
        
        self.pixels = pixels
        self.size = .init(width: width, height: height)
    }
    
}

extension PixelBuffer {
    
    enum InitializationError: Error {
        
        case mismatchedBufferSize(expected: Int, actual: Int)
        
    }
    
}
