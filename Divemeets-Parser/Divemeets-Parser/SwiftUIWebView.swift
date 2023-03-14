//
//  SwiftUIWebView.swift
//  Divemeets-Parser
//
//  Created by Logan Sherwin on 3/13/23.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: View {
    @State var request: String = "https://secure.meetcontrol.com/divemeets/system/profile.php?number=51197"
    @State var parsedHTML: String = ""
    
    var body: some View {
        VStack {
            Text(parsedHTML)
            WebView(request: $request, parsedHTML: $parsedHTML)
        }
    }
}

struct WebView: UIViewRepresentable {
    let htmlParser: HTMLParser = HTMLParser()
    @Binding var request: String
    @Binding var parsedHTML: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView: WKWebView = {
            //            let prefs = WKPreferences()
            //            prefs.javaScriptEnabled = true
            let pagePrefs = WKWebpagePreferences()
            pagePrefs.allowsContentJavaScript = true
            let config = WKWebViewConfiguration()
            //            config.preferences = prefs
            config.defaultWebpagePreferences = pagePrefs
            let webview = WKWebView(frame: .zero,
                                    configuration: config)
            webview.translatesAutoresizingMaskIntoConstraints = false
            return webview
        }()
        
        return webView
    }
    
    // from SwiftUI to UIKit
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: request) else { return }
        uiView.load(URLRequest(url: url))
        parsedHTML = htmlParser.parse(html: request)
    }
    
    // From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(html: $parsedHTML)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let htmlParser: HTMLParser = HTMLParser()
        @Binding var parsedHTML: String
        
        init(html: Binding<String>) {
            self._parsedHTML = html
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.innerHTML;") { [weak self] result, error in
                guard let html = result as? String, error == nil else { print("Failed to get HTML"); return
                }
                self?.parsedHTML = self?.htmlParser.parse(html: html) ?? ""
            }
        }
        
    }
}


struct SwiftUIWebView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIWebView()
    }
}
