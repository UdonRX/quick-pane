import SwiftUI
import WebKit
import UIKit

struct QuickPaneWebView: UIViewRepresentable {
    private let pageURL = URL(string: "https://udonrx.github.io/quick-pane/")!

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.load(URLRequest(url: pageURL))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Keep the existing page loaded when SwiftUI refreshes this view.
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Quick Pane's existing buttons use shortcuts://run-shortcut.
            // WKWebView doesn't reliably hand custom schemes to other apps,
            // so explicitly open those links through iOS and keep the page.
            if url.scheme?.lowercased() == "shortcuts" {
                UIApplication.shared.open(url, options: [:]) { _ in }
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
