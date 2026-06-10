import AppKit
import Foundation
import WebKit

final class Snapshotter: NSObject, WKNavigationDelegate {
    private let inputURL: URL
    private let outputURL: URL
    private let webView: WKWebView

    init(inputURL: URL, outputURL: URL) {
        self.inputURL = inputURL
        self.outputURL = outputURL
        self.webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 1440, height: 860))
        super.init()
        webView.navigationDelegate = self
    }

    func start() {
        webView.loadFileURL(inputURL, allowingReadAccessTo: inputURL.deletingLastPathComponent())
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let config = WKSnapshotConfiguration()
            config.rect = NSRect(x: 0, y: 0, width: 1440, height: 860)
            self.webView.takeSnapshot(with: config) { image, error in
                if let error {
                    self.fail("Snapshot failed: \(error.localizedDescription)")
                }

                guard let tiff = image?.tiffRepresentation,
                      let rep = NSBitmapImageRep(data: tiff),
                      let png = rep.representation(using: .png, properties: [:]) else {
                    self.fail("Could not encode snapshot PNG.")
                }

                do {
                    try png.write(to: self.outputURL)
                    print("Wrote: \(self.outputURL.path)")
                    exit(0)
                } catch {
                    self.fail("Could not write snapshot: \(error.localizedDescription)")
                }
            }
        }
    }

    private func fail(_ message: String) -> Never {
        fputs("\(message)\n", stderr)
        exit(1)
    }
}

let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputsRoot = projectRoot.appendingPathComponent("outputs", isDirectory: true)
try? FileManager.default.createDirectory(at: outputsRoot, withIntermediateDirectories: true)

let input = URL(fileURLWithPath: CommandLine.arguments.dropFirst().first ?? outputsRoot.appendingPathComponent("chiselo-five-slide-demo-edited.html").path)
let output = URL(fileURLWithPath: CommandLine.arguments.dropFirst().dropFirst().first ?? outputsRoot.appendingPathComponent("chiselo-five-slide-demo-edited-preview.png").path)

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)

let snapshotter = Snapshotter(inputURL: input, outputURL: output)
DispatchQueue.main.async {
    snapshotter.start()
}

app.run()
