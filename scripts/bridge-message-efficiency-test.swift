import AppKit
import Foundation
import WebKit

final class BridgeMessageEfficiencyTest: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    private let editorURL: URL
    private var webView: WKWebView?
    private var isMeasuringSelectionBridge = false
    private var selectionMessageCount = 0

    init(editorURL: URL) {
        self.editorURL = editorURL
    }

    func start() {
        let controller = WKUserContentController()
        controller.add(self, name: "chiselo")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller

        let webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 1180, height: 840), configuration: configuration)
        webView.navigationDelegate = self
        self.webView = webView
        webView.loadFileURL(editorURL, allowingReadAccessTo: editorURL.deletingLastPathComponent())

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.fail("Timed out waiting for bridge efficiency result.")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.runSelectionBridgeProbe()
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "chiselo",
              let body = message.body as? [String: Any],
              body["type"] as? String == "selectionChanged",
              isMeasuringSelectionBridge else {
            return
        }

        selectionMessageCount += 1
    }

    private func runSelectionBridgeProbe() {
        isMeasuringSelectionBridge = true
        selectionMessageCount = 0

        let script = """
        (() => {
          const editor = window.ChiseloEditor;
          if (!editor) throw new Error('ChiseloEditor is not available.');
          if (!window.__chiseloOriginalStringify) {
            window.__chiseloOriginalStringify = JSON.stringify;
          }
          window.__chiseloStringifyCount = 0;
          JSON.stringify = function(...args) {
            window.__chiseloStringifyCount += 1;
            return window.__chiseloOriginalStringify.apply(this, args);
          };

          const selection = editor.selectElementById('title');
          if (!selection) throw new Error('Could not select default title element.');
          return {
            selectedId: selection.id,
            stringifyCount: window.__chiseloStringifyCount
          };
        })();
        """

        webView?.evaluateJavaScript(script) { [weak self] result, error in
            guard let self else { return }
            if let error {
                fail("Selection bridge probe failed: \(error.localizedDescription)")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.finishProbe(initialResult: result)
            }
        }
    }

    private func finishProbe(initialResult: Any?) {
        isMeasuringSelectionBridge = false

        let script = """
        (() => {
          const count = window.__chiseloStringifyCount || 0;
          if (window.__chiseloOriginalStringify) {
            JSON.stringify = window.__chiseloOriginalStringify;
          }
          return {
            stringifyCount: count,
            selection: window.ChiseloEditor?.getSelection?.() || null
          };
        })();
        """

        webView?.evaluateJavaScript(script) { [weak self] result, error in
            guard let self else { return }
            if let error {
                fail("Finish bridge probe failed: \(error.localizedDescription)")
            }

            guard let body = result as? [String: Any],
                  let stringifyCount = bridgeInt(body["stringifyCount"]),
                  let selection = body["selection"] as? [String: Any],
                  selection["id"] as? String == "title" else {
                fail("Invalid bridge probe result: \(String(describing: result)), initial=\(String(describing: initialResult))")
            }

            guard stringifyCount == 0 else {
                fail("Selection bridge used JSON.stringify \(stringifyCount) time(s).")
            }

            guard selectionMessageCount > 0 else {
                fail("Selection bridge did not emit selectionChanged.")
            }

            let output: [String: Any] = [
                "type": "result",
                "selectionMessageCount": selectionMessageCount,
                "stringifyCount": stringifyCount,
                "selection": selection
            ]

            if let data = try? JSONSerialization.data(withJSONObject: output, options: [.prettyPrinted, .sortedKeys]),
               let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            exit(0)
        }
    }

    private func bridgeInt(_ value: Any?) -> Int? {
        switch value {
        case let int as Int:
            return int
        case let number as NSNumber:
            return number.intValue
        default:
            return nil
        }
    }

    private func fail(_ message: String) -> Never {
        fputs("Bridge message efficiency test failed: \(message)\n", stderr)
        exit(1)
    }
}

let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let editorURL = projectRoot
    .appendingPathComponent("Sources")
    .appendingPathComponent("Chiselo")
    .appendingPathComponent("Resources")
    .appendingPathComponent("Editor")
    .appendingPathComponent("index.html")

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)

let test = BridgeMessageEfficiencyTest(editorURL: editorURL)
DispatchQueue.main.async {
    test.start()
}

app.run()
