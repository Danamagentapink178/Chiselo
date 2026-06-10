import AppKit
import Foundation
import WebKit

final class SmokeTest: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    private let editorURL: URL
    private let htmlURL: URL
    private var webView: WKWebView?

    init(editorURL: URL, htmlURL: URL) {
        self.editorURL = editorURL
        self.htmlURL = htmlURL
    }

    func start() {
        let controller = WKUserContentController()
        controller.add(self, name: "smoke")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller

        let webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 1200, height: 900), configuration: configuration)
        webView.navigationDelegate = self
        self.webView = webView
        webView.loadFileURL(editorURL, allowingReadAccessTo: editorURL.deletingLastPathComponent())
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        do {
            let html = try String(contentsOf: htmlURL, encoding: .utf8)
            guard let data = html.data(using: .utf8) else {
                fail("Could not encode HTML as UTF-8.")
            }

            let base64 = data.base64EncodedString()
            let baseHref = htmlURL.deletingLastPathComponent().absoluteString
            let baseLiteral = try jsStringLiteral(baseHref)
            let script = """
            void window.ChiseloEditor.openHTMLFromBase64('\(base64)', \(baseLiteral))
              .then(() => {
                const before = window.ChiseloEditor.getHTMLSummary();
                const tree = window.ChiseloEditor.getHTMLTree();
                const flatten = (nodes) => nodes.flatMap((node) => [node, ...flatten(node.children || [])]);
                const treeNodes = flatten(tree);
                const treeTarget = treeNodes.find((node) => node.tagName === 'h1') || treeNodes.find((node) => node.tagName === 'header') || treeNodes[0];
                if (!treeTarget) throw new Error('DOM tree is empty');
                window.ChiseloEditor.selectHTMLById(treeTarget.id);
                window.ChiseloEditor.command('setLayoutTransform');
                const selected = window.ChiseloEditor.getSelection();
                if (selected) {
                  window.ChiseloEditor.updateElement({
                    ...selected,
                    x: selected.x + 12,
                    y: selected.y + 8,
                    w: selected.w,
                    h: selected.h,
                    style: {
                      ...selected.style,
                      color: 'rgb(1, 2, 3)',
                      fill: 'rgb(250, 250, 210)',
                      stroke: 'rgb(12, 34, 56)',
                      strokeWidth: 2,
                      radius: 6
                    }
                  });
                  window.ChiseloEditor.setSelectedHTMLText('CHISELO_DIRECT_EDIT_TEST');
                }
                window.ChiseloEditor.command('selectParent');
                const parentSelection = window.ChiseloEditor.getSelection();
                window.ChiseloEditor.command('duplicate');
                const duplicateSelection = window.ChiseloEditor.getSelection();
                const exported = window.ChiseloEditor.exportHTML();
                const after = window.ChiseloEditor.getHTMLSummary();
                const containsEditedText = exported.includes('CHISELO_DIRECT_EDIT_TEST');
                const duplicateCount = (exported.match(/CHISELO_DIRECT_EDIT_TEST/g) || []).length;
                const containsInlineTransform = exported.includes('transform:') && exported.includes('translate(');
                const containsStyleEdit = exported.includes('rgb(1, 2, 3)') && exported.includes('rgb(250, 250, 210)') && exported.includes('rgb(12, 34, 56)');
                const containsChiseloData = exported.includes('data-chiselo');
                if (!containsEditedText || duplicateCount < 2 || !containsInlineTransform || !containsStyleEdit || containsChiseloData || !tree.length || !treeTarget || !parentSelection || parentSelection.tagName !== 'header' || !duplicateSelection || duplicateSelection.tagName !== 'header') {
                  throw new Error(JSON.stringify({
                    containsEditedText,
                    duplicateCount,
                    containsInlineTransform,
                    containsStyleEdit,
                    containsChiseloData,
                    treeCount: treeNodes.length,
                    treeTargetTag: treeTarget && treeTarget.tagName,
                    parentTagName: parentSelection && parentSelection.tagName,
                    duplicateTagName: duplicateSelection && duplicateSelection.tagName,
                    exportedSnippet: exported.slice(0, 220)
                  }));
                }
                window.webkit.messageHandlers.smoke.postMessage({
                  type: 'result',
                  before,
                  after,
                  treeCount: treeNodes.length,
                  treeTarget,
                  selected,
                  parentSelection,
                  duplicateSelection,
                  parentSelectionIsHeader: parentSelection && parentSelection.tagName === 'header',
                  containsEditedText,
                  duplicateCount,
                  containsInlineTransform,
                  containsStyleEdit,
                  containsChiseloData,
                  exportedLength: exported.length
                });
              })
              .catch(error => {
                window.webkit.messageHandlers.smoke.postMessage({
                  type: 'error',
                  message: String(error && error.message || error),
                  stack: String(error && error.stack || '')
                });
              });
            """

            webView.evaluateJavaScript(script) { _, error in
                if let error {
                    self.fail("JavaScript evaluation failed: \(error.localizedDescription)")
                }
            }
        } catch {
            fail("Could not read HTML: \(error.localizedDescription)")
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "smoke", let body = message.body as? [String: Any] else { return }

        if body["type"] as? String == "error" {
            fail(body["message"] as? String ?? "Unknown JavaScript error.")
            return
        }

        if let data = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted, .sortedKeys]),
           let output = String(data: data, encoding: .utf8) {
            print(output)
            exit(0)
        }

        fail("Could not serialize smoke test result.")
    }

    private func jsStringLiteral(_ string: String) throws -> String {
        let data = try JSONEncoder().encode(string)
        return String(data: data, encoding: .utf8) ?? "\"\""
    }

    private func fail(_ message: String) -> Never {
        fputs("Smoke test failed: \(message)\n", stderr)
        exit(1)
    }
}

let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let editorURL = projectRoot
    .appendingPathComponent("Chiselo")
    .appendingPathComponent("Resources")
    .appendingPathComponent("Editor")
    .appendingPathComponent("index.html")

let htmlPath = CommandLine.arguments.dropFirst().first
    ?? projectRoot.appendingPathComponent("examples").appendingPathComponent("sample-html-page.html").path
let htmlURL = URL(fileURLWithPath: htmlPath)

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)

let smokeTest = SmokeTest(editorURL: editorURL, htmlURL: htmlURL)
DispatchQueue.main.async {
    smokeTest.start()
}

app.run()
