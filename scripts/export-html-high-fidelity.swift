import AppKit
import Foundation

@main
struct ExportHTMLHighFidelity {
    @MainActor private static var activeRenderer: HTMLRenderExporter?

    static func main() {
        let args = CommandLine.arguments
        let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputsRoot = projectRoot.appendingPathComponent("outputs", isDirectory: true)
        try? FileManager.default.createDirectory(at: outputsRoot, withIntermediateDirectories: true)
        let input = URL(fileURLWithPath: args.dropFirst().first ?? outputsRoot.appendingPathComponent("digital-transformation-10-slides-edited.html").path)
        let output = URL(fileURLWithPath: args.dropFirst().dropFirst().first ?? outputsRoot.appendingPathComponent("digital-transformation-10-slides.pptx").path)
        let requestedFormat = args.dropFirst().dropFirst().dropFirst().first ?? output.pathExtension.lowercased()
        guard let format = ExportFormat(requestedFormat) else {
            fputs("Export failed: unsupported format '\(requestedFormat)'. Use pdf, editable-pptx, or image-pptx.\n", stderr)
            exit(2)
        }

        let app = NSApplication.shared
        app.setActivationPolicy(.prohibited)

        Task { @MainActor in
            do {
                let html = try String(contentsOf: input, encoding: .utf8)
                let renderer = HTMLRenderExporter(html: html, baseURL: input.deletingLastPathComponent())
                activeRenderer = renderer

                if format == .pdf || format == .imagePPTX {
                    renderer.renderPages { result in
                        Task { @MainActor in
                            activeRenderer = nil
                            do {
                                let pages = try result.get()
                                if format == .pdf {
                                    try HTMLRenderExporter.writePDF(pages: pages, to: output)
                                } else {
                                    try HTMLRenderExporter.writePPTX(pages: pages, to: output)
                                }
                                print("Exported \(pages.count) page(s): \(output.path)")
                                exit(0)
                            } catch {
                                fputs("Export failed: \(error.localizedDescription)\n", stderr)
                                exit(1)
                            }
                        }
                    }
                } else {
                    renderer.renderEditablePages { result in
                        Task { @MainActor in
                            activeRenderer = nil
                            do {
                                let pages = try result.get()
                                try HTMLRenderExporter.writeEditablePPTX(pages: pages, to: output, baseURL: input.deletingLastPathComponent())
                                print("Exported editable \(pages.count) page(s): \(output.path)")
                                exit(0)
                            } catch {
                                fputs("Export failed: \(error.localizedDescription)\n", stderr)
                                exit(1)
                            }
                        }
                    }
                }
            } catch {
                fputs("Export failed: \(error.localizedDescription)\n", stderr)
                exit(1)
            }
        }

        app.run()
    }

    private enum ExportFormat: Equatable {
        case pdf
        case imagePPTX
        case editablePPTX

        init?(_ rawValue: String) {
            switch rawValue.lowercased() {
            case "pdf":
                self = .pdf
            case "pptx", "editable", "editable-pptx", "object-pptx":
                self = .editablePPTX
            case "image-pptx", "high-fidelity-pptx", "rendered-pptx":
                self = .imagePPTX
            default:
                return nil
            }
        }
    }
}
