//
//  CooperationDetailsController.swift
//  MR007
//
//  Created by GreatFeat on 22/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class CooperationDetailsController: BaseViewController {
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding webView content
        do {
            guard let filePath = Bundle.main.path(forResource: "hezuofangan", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }

            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
    }


}
