//
//  WebViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import WebKit

final class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    var urlString = ""
    var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        webView.navigationDelegate = self
        guard let url = URL(string: urlString) else {
            return
        }
        title = titleString
        view.showOverlayIndicator()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension WebViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideOverlayIndicator()
    }
}
