//
//  KeypadView.swift
//  MR007
//
//  Created by GreatFeat on 16/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class KeypadView: UIView {
    var cursorView: UIView? = nil
    var amountLabel: AmountLabel? = nil

    class func loadView() -> KeypadView {
        let nib = UINib(nibName: "KeypadView", bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        let view = views[0] as? KeypadView
        return view!
    }

    func set(inputView: inout AmountLabel!) {
        self.amountLabel = inputView
        self.amountLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(KeypadView.handleTapAmountField(recognizer:))))
    }

    func handleTapAmountField(recognizer: UITapGestureRecognizer) {
        self.startEditing()
    }

    func startEditing() {
        if self.cursorView == nil {
            self.amountLabel?.textColor = UIColor.black
            self.amountLabel?.text = ""
            let height = (self.amountLabel?.frame.height)! - 10
            let rect = CGRect(x: positionX(), y: 5, width: 2, height: height)
            self.cursorView = UIView(frame: rect)
            self.cursorView?.backgroundColor = UIColor.black
            self.amountLabel?.addSubview(self.cursorView!)

            UIView.animate(withDuration: 1.0, delay: 0, options: .repeat, animations: {
                self.cursorView?.alpha = 0.1
            }, completion: { (flag) in
                self.cursorView?.alpha = 1.0
            })
        }
    }

    @IBAction func keyPress(_ button: UIButton) {
        self.startEditing()
        self.amountLabel?.text?.append((button.titleLabel?.text)!)
        self.cursorView?.frame.origin.x = positionX()
    }

    @IBAction func returnPress(_ button: UIButton) {

    }

    @IBAction func backspcePress(_ button: UIButton) {
        var text = self.amountLabel?.text
        if (text?.characters.count)! > 0 {
            let index = text?.characters.endIndex
            self.amountLabel?.text = text?.substring(to: (text?.characters.index(index!, offsetBy: -1))!)
            self.cursorView?.frame.origin.x = positionX()
        }
    }

    func positionX() -> CGFloat {
        let textSize: CGSize = self.amountLabel!.text!.size(attributes: [NSFontAttributeName:self.amountLabel!.font])
        return textSize.width + 5
    }
}
