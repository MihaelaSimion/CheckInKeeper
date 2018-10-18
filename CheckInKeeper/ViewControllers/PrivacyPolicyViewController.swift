//
//  PrivacyPolicyViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 10/17/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.backgroundColor = Constants.Colors.backgroundColor
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(.white, for: .normal)

        guard let url = URL(string: "https://www.websitepolicies.com/policies/view/156hxlZ9") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    @IBAction private func dismissButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
