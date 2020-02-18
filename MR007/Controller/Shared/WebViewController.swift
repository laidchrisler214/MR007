//
//  WebViewController.swift
//  MR007
//
//  Created by Roger Molas on 14/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnScan: UIButton!

    var urlString = ""
    var titleString = ""
    var isPresented:Bool = false
    let currentImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleString

        if isPresented {
            let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WebViewController.doneAction))
            navigationItem.leftBarButtonItem = done

            let scan = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(WebViewController.scanQR))
            navigationItem.rightBarButtonItem = scan
        }
    }

    func doneAction () {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webview.loadRequest(URLRequest(url: (URL(string: self.urlString)!)))
    }

    func scanQR () {
        let rect = self.view.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        self.view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.performSegue(withIdentifier: "QR", sender: image)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reader = segue.destination as? QRReaderViewController
        let image = sender as? UIImage
        reader?.currentImage = image
    }
}

// MARK - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activity.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activity.stopAnimating()
    }
}
