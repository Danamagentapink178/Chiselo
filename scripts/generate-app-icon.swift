#!/usr/bin/env swift

import AppKit
import Foundation

let fileManager = FileManager.default

func outputURL() -> URL {
    let path = CommandLine.arguments.dropFirst().first
        ?? "Sources/Chiselo/Resources/AppIcon"
    if path.hasPrefix("/") {
        return URL(fileURLWithPath: path)
    }
    return URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(path)
}

func color(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
    let red = CGFloat((hex >> 16) & 0xff) / 255
    let green = CGFloat((hex >> 8) & 0xff) / 255
    let blue = CGFloat(hex & 0xff) / 255
    return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func roundedFill(_ rect: NSRect, radius: CGFloat, fill: NSColor) {
    fill.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func roundedStroke(_ rect: NSRect, radius: CGFloat, stroke: NSColor, width: CGFloat) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    path.lineWidth = width
    stroke.setStroke()
    path.stroke()
}

func drawLine(from start: NSPoint, to end: NSPoint, color stroke: NSColor, width: CGFloat) {
    let path = NSBezierPath()
    path.move(to: start)
    path.line(to: end)
    path.lineWidth = width
    stroke.setStroke()
    path.stroke()
}

func drawCenteredText(_ text: String, in rect: NSRect, size: CGFloat, color fill: NSColor) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center

    let font = NSFont(name: "SFProRounded-Black", size: size)
        ?? NSFont.systemFont(ofSize: size, weight: .black)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: fill,
        .paragraphStyle: paragraph
    ]
    let attributed = NSAttributedString(string: text, attributes: attributes)
    let textSize = attributed.size()
    let textRect = NSRect(
        x: rect.midX - textSize.width / 2,
        y: rect.midY - textSize.height / 2 - size * 0.035,
        width: textSize.width,
        height: textSize.height
    )
    attributed.draw(in: textRect)
}

func drawArtwork() {
    let outerRect = NSRect(x: 76, y: 76, width: 872, height: 872)
    let outerPath = NSBezierPath(roundedRect: outerRect, xRadius: 210, yRadius: 210)

    NSGraphicsContext.saveGraphicsState()
    let iconShadow = NSShadow()
    iconShadow.shadowColor = NSColor.black.withAlphaComponent(0.24)
    iconShadow.shadowBlurRadius = 62
    iconShadow.shadowOffset = NSSize(width: 0, height: -22)
    iconShadow.set()
    color(0x6d50b4).setFill()
    outerPath.fill()
    NSGraphicsContext.restoreGraphicsState()

    NSGraphicsContext.saveGraphicsState()
    outerPath.addClip()
    NSGradient(colors: [
        color(0xfaf7ff),
        color(0xe8ddff),
        color(0x8b73d4),
        color(0x4f3b87)
    ])?.draw(in: outerRect, angle: -35)

    color(0xffffff, alpha: 0.20).setStroke()
    let grid = NSBezierPath()
    for x in stride(from: 132 as CGFloat, through: 900, by: 64) {
        grid.move(to: NSPoint(x: x, y: 120))
        grid.line(to: NSPoint(x: x, y: 904))
    }
    for y in stride(from: 132 as CGFloat, through: 900, by: 64) {
        grid.move(to: NSPoint(x: 120, y: y))
        grid.line(to: NSPoint(x: 904, y: y))
    }
    grid.lineWidth = 2
    grid.stroke()
    NSGraphicsContext.restoreGraphicsState()

    let cardRect = NSRect(x: 222, y: 214, width: 580, height: 596)
    let cardPath = NSBezierPath(roundedRect: cardRect, xRadius: 78, yRadius: 78)

    NSGraphicsContext.saveGraphicsState()
    let cardShadow = NSShadow()
    cardShadow.shadowColor = NSColor.black.withAlphaComponent(0.20)
    cardShadow.shadowBlurRadius = 34
    cardShadow.shadowOffset = NSSize(width: 0, height: -15)
    cardShadow.set()
    color(0xffffff).setFill()
    cardPath.fill()
    NSGraphicsContext.restoreGraphicsState()

    roundedFill(cardRect, radius: 78, fill: color(0xffffff))
    NSGraphicsContext.saveGraphicsState()
    cardPath.addClip()
    roundedFill(NSRect(x: 222, y: 730, width: 580, height: 80), radius: 78, fill: color(0xf3eefb))
    color(0x6d50b4, alpha: 0.12).setStroke()
    for x in stride(from: 282 as CGFloat, through: 742, by: 58) {
        drawLine(from: NSPoint(x: x, y: 278), to: NSPoint(x: x, y: 706), color: color(0x6d50b4, alpha: 0.10), width: 3)
    }
    for y in stride(from: 292 as CGFloat, through: 692, by: 58) {
        drawLine(from: NSPoint(x: 264, y: y), to: NSPoint(x: 760, y: y), color: color(0x6d50b4, alpha: 0.10), width: 3)
    }
    NSGraphicsContext.restoreGraphicsState()

    roundedFill(NSRect(x: 286, y: 758, width: 22, height: 22), radius: 11, fill: color(0xff5f57))
    roundedFill(NSRect(x: 326, y: 758, width: 22, height: 22), radius: 11, fill: color(0xffbd2e))
    roundedFill(NSRect(x: 366, y: 758, width: 22, height: 22), radius: 11, fill: color(0x28c840))

    let selectionRect = NSRect(x: 284, y: 300, width: 456, height: 394)
    roundedStroke(selectionRect, radius: 34, stroke: color(0x6d50b4, alpha: 0.86), width: 14)

    for point in [
        NSPoint(x: 270, y: 286), NSPoint(x: 498, y: 286), NSPoint(x: 726, y: 286),
        NSPoint(x: 270, y: 497), NSPoint(x: 726, y: 497),
        NSPoint(x: 270, y: 680), NSPoint(x: 498, y: 680), NSPoint(x: 726, y: 680)
    ] {
        let rect = NSRect(x: point.x, y: point.y, width: 44, height: 44)
        roundedFill(rect, radius: 14, fill: color(0xffffff))
        roundedStroke(rect, radius: 14, stroke: color(0x6d50b4), width: 8)
    }

    let markColor = color(0x15151b)
    drawCenteredText("C", in: NSRect(x: 290, y: 330, width: 440, height: 330), size: 330, color: markColor)
    roundedFill(NSRect(x: 552, y: 526, width: 126, height: 34), radius: 17, fill: color(0xffc107))
    roundedFill(NSRect(x: 640, y: 526, width: 58, height: 34), radius: 17, fill: color(0xc62828))

    color(0xffffff, alpha: 0.92).setStroke()
    let tagLeft = NSBezierPath()
    tagLeft.move(to: NSPoint(x: 312, y: 604))
    tagLeft.line(to: NSPoint(x: 260, y: 550))
    tagLeft.line(to: NSPoint(x: 312, y: 496))
    tagLeft.lineWidth = 18
    tagLeft.lineJoinStyle = .round
    tagLeft.lineCapStyle = .round
    tagLeft.stroke()

    let tagRight = NSBezierPath()
    tagRight.move(to: NSPoint(x: 712, y: 604))
    tagRight.line(to: NSPoint(x: 764, y: 550))
    tagRight.line(to: NSPoint(x: 712, y: 496))
    tagRight.lineWidth = 18
    tagRight.lineJoinStyle = .round
    tagRight.lineCapStyle = .round
    tagRight.stroke()

    let cursor = NSBezierPath()
    cursor.move(to: NSPoint(x: 646, y: 286))
    cursor.line(to: NSPoint(x: 818, y: 172))
    cursor.line(to: NSPoint(x: 744, y: 164))
    cursor.line(to: NSPoint(x: 786, y: 80))
    cursor.line(to: NSPoint(x: 726, y: 52))
    cursor.line(to: NSPoint(x: 686, y: 138))
    cursor.line(to: NSPoint(x: 636, y: 92))
    cursor.close()

    NSGraphicsContext.saveGraphicsState()
    let cursorShadow = NSShadow()
    cursorShadow.shadowColor = NSColor.black.withAlphaComponent(0.24)
    cursorShadow.shadowBlurRadius = 16
    cursorShadow.shadowOffset = NSSize(width: 0, height: -7)
    cursorShadow.set()
    color(0xffffff).setFill()
    cursor.fill()
    NSGraphicsContext.restoreGraphicsState()

    cursor.lineWidth = 12
    color(0x4f3b87).setStroke()
    cursor.stroke()

    roundedStroke(outerRect.insetBy(dx: 3, dy: 3), radius: 206, stroke: color(0xffffff, alpha: 0.45), width: 6)
}

func pngData(size: Int) throws -> Data {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: size,
        pixelsHigh: size,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 32
    ) else {
        throw NSError(domain: "ChiseloIcon", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create bitmap"])
    }

    rep.size = NSSize(width: size, height: size)
    guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
        throw NSError(domain: "ChiseloIcon", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not create graphics context"])
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    context.imageInterpolation = .high
    NSColor.clear.setFill()
    NSRect(x: 0, y: 0, width: size, height: size).fill()
    context.cgContext.scaleBy(x: CGFloat(size) / 1024, y: CGFloat(size) / 1024)
    drawArtwork()
    context.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()

    guard let data = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "ChiseloIcon", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not encode PNG"])
    }
    return data
}

let output = outputURL()
let iconset = output.appendingPathComponent("Chiselo.iconset", isDirectory: true)
let icns = output.appendingPathComponent("Chiselo.icns")
try fileManager.createDirectory(at: output, withIntermediateDirectories: true)
if fileManager.fileExists(atPath: iconset.path) {
    try fileManager.removeItem(at: iconset)
}
try fileManager.createDirectory(at: iconset, withIntermediateDirectories: true)

let files: [(String, Int)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

for (name, size) in files {
    try pngData(size: size).write(to: iconset.appendingPathComponent(name))
}

if fileManager.fileExists(atPath: icns.path) {
    try fileManager.removeItem(at: icns)
}

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
process.arguments = ["-c", "icns", iconset.path, "-o", icns.path]
try process.run()
process.waitUntilExit()

guard process.terminationStatus == 0 else {
    throw NSError(domain: "ChiseloIcon", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: "iconutil failed"])
}

print("Created: \(icns.path)")
