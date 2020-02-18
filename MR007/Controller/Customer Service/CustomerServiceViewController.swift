//
//  CustomerServiceViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 25/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class CustomerServiceViewController: MRViewController {

    @IBOutlet weak var webView: UIWebView!

    //mark: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.loadRequest(URLRequest(url: (URL(string: Endpoint.aboutBlank)!)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.loadRequest(URLRequest(url: (URL(string: Endpoint.chat)!)))
    }

    //mark: Methods
    func setView() {
        self.setNavigationBarItem() //Setup sliding controller functions
    }

}
