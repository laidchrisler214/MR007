//
//  DepositOnlineWebViewController.swift
//  MR007
//
//  Created by GreatFeat on 19/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositOnlineWebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!

    var htmlString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(htmlString, baseURL: nil)

    }

    @IBAction func doneAction(_ sender: Any) {
        self.performSegueToReturnBack()
    }

}
