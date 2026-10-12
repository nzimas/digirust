import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let size = 1024
let space = CGColorSpaceCreateDeviceRGB()
let context = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
let plate = CGPath(roundedRect: CGRect(x: 30, y: 30, width: 964, height: 964), cornerWidth: 222, cornerHeight: 222, transform: nil)
context.addPath(plate); context.clip()
let colors = [CGColor(red: 0.07, green: 0.085, blue: 0.11, alpha: 1), CGColor(red: 0.18, green: 0.15, blue: 0.145, alpha: 1)] as CFArray
let gradient = CGGradient(colorsSpace: space, colors: colors, locations: [0,1])!
context.drawLinearGradient(gradient, start: CGPoint(x: 512, y: 0), end: CGPoint(x: 512, y: 1024), options: [])
let heights: [CGFloat] = [0.25,0.47,0.70,0.36,0.58,0.27]
context.setFillColor(CGColor(red: 0.96, green: 0.65, blue: 0.42, alpha: 1))
for (i,h) in heights.enumerated() {
    let width: CGFloat = 68, height = 1024*h
    context.addPath(CGPath(roundedRect: CGRect(x: 1024*(0.20+CGFloat(i)*0.108), y: (1024-height)/2, width: width, height: height), cornerWidth: width/2, cornerHeight: width/2, transform: nil)); context.fillPath()
}
let image = context.makeImage()!
let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(destination, image, nil)
precondition(CGImageDestinationFinalize(destination))
