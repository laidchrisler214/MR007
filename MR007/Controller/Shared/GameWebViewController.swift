//
//  GameWebViewController.swift
//  MR007
//
//  Created by Roger Molas on 01/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class GameWebViewController: MRViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    var url = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.loadRequest(URLRequest(url: (URL(string: self.url)!)))
    }
}

// MARK - UIWebViewDelegate
extension GameWebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activity.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activity.stopAnimating()
    }
}
