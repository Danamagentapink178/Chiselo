import AppKit
import Foundation

@main
struct RenderHTMLPages {
    @MainActor private static var activeRenderer: HTMLRenderExporter?

    static func main() {
        let args = CommandLine.arguments
        let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputsRoot = projectRoot.appendingPathComponent("outputs", isDirectory: true)
        let input = URL(fileURLWithPath: args.dropFirst().first ?? projectRoot.appendingPathComponent("examples").appendingPathComponent("sample-html-page.html").path)
        let outputRoot = URL(fileURLWithPath: args.dropFirst().dropFirst().first ?? outputsRoot.appendingPathComponent("rendered-pages").path)

        let app = NSApplication.shared
        app.setActivationPolicy(.prohibited)

        Task { @MainActor in
            do {
                try FileManager.default.createDirectory(at: outputRoot, withIntermediateDirectories: true)
                let html = try String(contentsOf: input, encoding: .utf8)
                let renderer = HTMLRenderExporter(html: html, baseURL: input.deletingLastPathComponent())
                activeRenderer = renderer
                renderer.renderPages { result in
                    Task { @MainActor in
                        activeRenderer = nil
                        do {
                            let pages = try result.get()
                            for page in pages {
                                let name = String(format: "page-%02d.png", page.index)
                                let url = outputRoot.appendingPathComponent(name)
                                try page.pngData.write(to: url)
                                print("Wrote page \(page.index): \(url.path)")
                            }
                            exit(0)
                        } catch {
                            fputs("Render pages failed: \(error.localizedDescription)\n", stderr)
                            exit(1)
                        }
                    }
                }
            } catch {
                fputs("Render pages failed: \(error.localizedDescription)\n", stderr)
                exit(1)
            }
        }

        app.run()
    }
}
