import SwiftUI
import WebKit

struct QuickPaneWebView: UIViewRepresentable {
    private let pageURL = URL(string: "https://udonrx.github.io/quick-pane/")!

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
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
}
