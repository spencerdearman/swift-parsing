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
    
    var body: some View {
        WebView(request: $request)
    }
}

struct WebView: UIViewRepresentable {
    
    @Binding var request: String
    
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
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: request) else { return }
        uiView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parser: HTMLParser
        
        override init() {
            self.parser = HTMLParser()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.innerHTML;") { [weak self] result, error in
                guard let html = result as? String, error == nil else { print("Failed to get HTML"); return
                }
                
                self?.parser.parse(html: html)
            }
        }
        
    }
}


struct SwiftUIWebView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIWebView()
    }
}
