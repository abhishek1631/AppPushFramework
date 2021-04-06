//
//  WKWebView.swift
//  PushFramework
//
//  Created by Abhishek on 11/03/21.
//

import UIKit
import WebKit

class WKWebViewController : UIViewController {
    
    private lazy var webView : WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private let url : URL
    
    init(url : URL,title : String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
        webView.load(URLRequest(url: self.url))
        configurationButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configurationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissWebview))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadURL))
    }
    
    @objc private func dismissWebview() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reloadURL() {
        webView.load(URLRequest(url: self.url))
    }
}
