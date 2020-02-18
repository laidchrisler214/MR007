//
//  UIAlertView.swift
//  MR007
//
//  Created by GreatFeat on 23/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class  UIAlertView: UIAlertController {

    let viewController = UIViewController()
    var textView: UITextView? = UITextView(frame: CGRect.zero)
    var content: NSString? = "Test st ring Test string Test string Test string Test string Test string Test string Test \n string Test string Test string Test string Test string Test string Test string Test string Test string Test string Test string."

    var maxWidth: CGFloat = 272.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title View
        let titleFrame = CGRect(x: 0, y: 0, width: maxWidth, height: 50.0)
        let titleView = UIView(frame: titleFrame)
        titleView.backgroundColor = UIColor.clear

        // TextView
        textView?.font = UIFont.systemFont(ofSize: 14.0)
        textView?.backgroundColor = UIColor.clear
        textView?.isEditable = false
        textView?.isScrollEnabled = false
        textView?.text = content! as String
//        let size = content?.size(attributes: [NSFontAttributeName: textView!.font!])
        let textFrame = CGRect(x: 10, y: titleFrame.size.height, width:  maxWidth - 20, height: 100)
        textView?.frame = textFrame

        // Button View
        let position =  titleFrame.size.height + (textView?.frame.size.height)!
        let buttonFrame = CGRect(x: 0, y: position, width: maxWidth, height: 60.0)
        let buttonView = UIView(frame: buttonFrame)
        titleView.backgroundColor = UIColor.clear

        self.viewController.view.addSubview(titleView)
        self.viewController.view.addSubview(textView!)
        self.viewController.view.addSubview(buttonView)
        self.viewController.view.bringSubview(toFront: textView!)

        let vcHeight = (titleView.frame.size.height + (textView?.frame.size.height)!) + buttonView.frame.size.height
        self.viewController.preferredContentSize = CGSize(width: maxWidth, height: vcHeight)
        self.setValue(self.viewController, forKey: "contentViewController")
    }
}
