//
//  VersionUpdateViewController.swift
//  MR007
//
//  Created by Roger Molas on 20/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class VersionUpdateViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    public var urlstring = ""

    func getUrlRequest() -> URLRequest? {
        let url = URL(string: self.urlstring)
        if self.urlstring != "" {
            let urlRequest = URLRequest(url: url!)
            return urlRequest
        }
        return nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.loadRequest(self.getUrlRequest()!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.loadRequest(self.getUrlRequest()!)
    }
}
