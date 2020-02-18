//
//  WebViewCell.swift
//  MR007
//
//  Created by GreatFeat on 22/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class WebViewCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
    var htmlFile = ["1", "2", "3", "4"]

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setWebView(index: Int) {
        do {
            guard let filePath = Bundle.main.path(forResource: htmlFile[index], ofType: "html")
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
