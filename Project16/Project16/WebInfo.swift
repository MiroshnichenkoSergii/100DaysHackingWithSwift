//
//  WebInfo.swift
//  Project16
//
//  Created by Sergii Miroshnichenko on 30.06.2022.
//

import UIKit
import WebKit

class WebInfo: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    var selectedWebForCity: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: selectedWebForCity)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
