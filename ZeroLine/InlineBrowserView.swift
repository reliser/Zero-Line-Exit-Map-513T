import SwiftUI
import WebKit

struct InlineBrowserView: UIViewRepresentable {

    let targetURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences

        let browser = WKWebView(frame: .zero, configuration: config)
        browser.allowsBackForwardNavigationGestures = true
        browser.scrollView.bounces = true
        browser.isOpaque = false
        browser.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1, webview_aso_ios_3"

        let request = URLRequest(url: targetURL)
        browser.load(request)

        return browser
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
