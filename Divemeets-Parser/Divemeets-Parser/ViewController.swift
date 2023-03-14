//
//  ViewController.swift
//  Divemeets-Parser
//
//  Created by Spencer Dearman on 3/3/23.
//

import WebKit
import UIKit
import SwiftUI

final class ViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let pagePrefs = WKWebpagePreferences()
        pagePrefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        config.defaultWebpagePreferences = pagePrefs
        let webview = WKWebView(frame: .zero,
                                configuration: config)
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    private let parser = HTMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for the load url function we can add a place where they
        //put the idnumber because the website is easily searchable
        guard let url = URL(string: "https://secure.meetcontrol.com/divemeets/system/profile.php?number=51197") else { return}
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML;") { [weak self] result, error in
            guard let html = result as? String, error == nil else { print("Failed to get HTML"); return
            }
            
            self?.parser.parse(html: html)
        }
    }
}
