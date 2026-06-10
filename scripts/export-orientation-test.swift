import AppKit
import Foundation
import PDFKit

@main
struct ExportOrientationTest {
    @MainActor private static var activeRenderer: HTMLRenderExporter?

    static func main() {
        let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputsRoot = projectRoot.appendingPathComponent("outputs", isDirectory: true)
        let outputRoot = URL(
            fileURLWithPath: CommandLine.arguments.dropFirst().first
                ?? outputsRoot.appendingPathComponent("export-orientation-test").path,
            isDirectory: true
        )

        let app = NSApplication.shared
        app.setActivationPolicy(.prohibited)

        Task { @MainActor in
            do {
                try FileManager.default.removeItemIfExists(at: outputRoot)
                try FileManager.default.createDirectory(at: outputRoot, withIntermediateDirectories: true)

                let htmlURL = outputRoot.appendingPathComponent("orientation-fixture.html")
                let pdfURL = outputRoot.appendingPathComponent("orientation-fixture.pdf")
                let renderedPNGURL = outputRoot.appendingPathComponent("orientation-snapshot.png")
                let pdfPreviewURL = outputRoot.appendingPathComponent("orientation-pdf-preview.png")
                try fixtureHTML.write(to: htmlURL, atomically: true, encoding: .utf8)

                let renderer = HTMLRenderExporter(html: fixtureHTML, baseURL: outputRoot)
                activeRenderer = renderer
                renderer.renderPages { result in
                    Task { @MainActor in
                        activeRenderer = nil
                        do {
                            let pages = try result.get()
                            guard let page = pages.first, pages.count == 1 else {
                                throw TestError("Expected exactly one rendered page, got \(pages.count).")
                            }

                            try page.pngData.write(to: renderedPNGURL)
                            try assertCorners(inPNGData: page.pngData, label: "WK snapshot")

                            try HTMLRenderExporter.writePDF(pages: pages, to: pdfURL)
                            try assertPDFCorners(pdfURL: pdfURL, previewURL: pdfPreviewURL)

                            print("Export orientation OK")
                            print("Snapshot: \(renderedPNGURL.path)")
                            print("PDF: \(pdfURL.path)")
                            print("PDF preview: \(pdfPreviewURL.path)")
                            exit(0)
                        } catch {
                            fputs("Export orientation failed: \(error.localizedDescription)\n", stderr)
                            exit(1)
                        }
                    }
                }
            } catch {
                fputs("Export orientation failed: \(error.localizedDescription)\n", stderr)
                exit(1)
            }
        }

        app.run()
    }

    private static let fixtureHTML = """
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Chiselo Export Orientation Fixture</title>
      <style>
        html, body {
          margin: 0;
          padding: 0;
          background: #ffffff;
        }
        .slide {
          position: relative;
          width: 960px;
          height: 540px;
          overflow: hidden;
          background: #ffffff;
          font-family: Arial, sans-serif;
        }
        .corner {
          position: absolute;
          width: 140px;
          height: 140px;
        }
        .tl { left: 0; top: 0; background: #ff0000; }
        .tr { right: 0; top: 0; background: #00ff00; }
        .bl { left: 0; bottom: 0; background: #0000ff; }
        .br { right: 0; bottom: 0; background: #ffff00; }
        .top-label {
          position: absolute;
          left: 180px;
          top: 42px;
          font-size: 48px;
          line-height: 1;
          font-weight: 900;
          color: #111111;
        }
        .bottom-label {
          position: absolute;
          left: 180px;
          bottom: 50px;
          font-size: 40px;
          line-height: 1;
          font-weight: 800;
          color: #111111;
        }
      </style>
    </head>
    <body>
      <section class="slide">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>
        <div class="top-label">TOP LEFT</div>
        <div class="bottom-label">BOTTOM LEFT</div>
      </section>
    </body>
    </html>
    """

    private static func assertPDFCorners(pdfURL: URL, previewURL: URL) throws {
        guard let document = PDFDocument(url: pdfURL),
              let page = document.page(at: 0) else {
            throw TestError("Could not open exported PDF.")
        }

        let bounds = page.bounds(for: .mediaBox)
        let width = Int(bounds.width.rounded())
        let height = Int(bounds.height.rounded())
        guard width > 0, height > 0 else {
            throw TestError("Exported PDF has an invalid page size.")
        }

        guard let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: width,
            pixelsHigh: height,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ), let graphics = NSGraphicsContext(bitmapImageRep: bitmap) else {
            throw TestError("Could not create PDF preview bitmap.")
        }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = graphics
        NSColor.white.setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 0, width: width, height: height)).fill()
        page.draw(with: .mediaBox, to: graphics.cgContext)
        NSGraphicsContext.restoreGraphicsState()

        guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw TestError("Could not encode PDF preview PNG.")
        }
        try pngData.write(to: previewURL)
        try assertCorners(inBitmap: bitmap, label: "PDF preview")
    }

    private static func assertCorners(inPNGData data: Data, label: String) throws {
        guard let bitmap = NSBitmapImageRep(data: data) else {
            throw TestError("Could not decode \(label) PNG.")
        }
        try assertCorners(inBitmap: bitmap, label: label)
    }

    private static func assertCorners(inBitmap bitmap: NSBitmapImageRep, label: String) throws {
        let width = bitmap.pixelsWide
        let height = bitmap.pixelsHigh
        let samples: [(String, Int, Int, RGB)] = [
            ("top-left", 42, 42, RGB(255, 0, 0)),
            ("top-right", width - 42, 42, RGB(0, 255, 0)),
            ("bottom-left", 42, height - 42, RGB(0, 0, 255)),
            ("bottom-right", width - 42, height - 42, RGB(255, 255, 0))
        ]

        for sample in samples {
            let actual = try color(in: bitmap, x: sample.1, y: sample.2)
            guard actual.isClose(to: sample.3) else {
                throw TestError("\(label) \(sample.0) expected \(sample.3.description), got \(actual.description).")
            }
        }
    }

    private static func color(in bitmap: NSBitmapImageRep, x: Int, y: Int) throws -> RGB {
        guard let color = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.deviceRGB) else {
            throw TestError("Could not sample bitmap at \(x), \(y).")
        }

        return RGB(
            UInt8((color.redComponent * 255).rounded()),
            UInt8((color.greenComponent * 255).rounded()),
            UInt8((color.blueComponent * 255).rounded())
        )
    }

    private struct RGB: CustomStringConvertible {
        var r: UInt8
        var g: UInt8
        var b: UInt8

        init(_ r: UInt8, _ g: UInt8, _ b: UInt8) {
            self.r = r
            self.g = g
            self.b = b
        }

        var description: String {
            "#\(String(format: "%02X%02X%02X", r, g, b))"
        }

        func isClose(to other: RGB, tolerance: Int = 64) -> Bool {
            abs(Int(r) - Int(other.r)) <= tolerance
                && abs(Int(g) - Int(other.g)) <= tolerance
                && abs(Int(b) - Int(other.b)) <= tolerance
        }
    }

    private struct TestError: LocalizedError {
        var message: String

        init(_ message: String) {
            self.message = message
        }

        var errorDescription: String? {
            message
        }
    }
}

private extension FileManager {
    func removeItemIfExists(at url: URL) throws {
        guard fileExists(atPath: url.path) else { return }
        try removeItem(at: url)
    }
}
