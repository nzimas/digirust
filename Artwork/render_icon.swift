import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

@main
struct RenderIcon {
    static func main() {
        let size = 1024
        let space = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        let plate = CGPath(roundedRect: CGRect(x: 30, y: 30, width: 964, height: 964), cornerWidth: 222, cornerHeight: 222, transform: nil)
        context.addPath(plate); context.clip()
        context.setFillColor(CGColor(red: 0.024, green: 0.027, blue: 0.039, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: size, height: size))
        drawDigiRustEmblem(context, in: CGRect(x: 90, y: 90, width: 844, height: 844))
        let image = context.makeImage()!
        let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(destination, image, nil)
        precondition(CGImageDestinationFinalize(destination))
    }
}
