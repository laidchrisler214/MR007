//
//  PromoDetailsViewController.swift
//  MR007
//
//  Created by GreatFeat on 21/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class PromoDetailsViewController: BaseViewController {
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    
    var bannerImage = String()
    var bannerDetails = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        setWebView()
    }
    
    func setBanner() {
        let htmlString = bannerImage
        let encodedHtmlString = htmlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        imageOutlet.kf.setImage(with: URL(string: encodedHtmlString!))
    }
    
    func setWebView() {
        webView.loadHTMLString(bannerDetails, baseURL: nil)
    }

}
