//
//  AlertViewTransferOut.swift
//  MR007
//
//  Created by Roger Molas on 14/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

protocol AlertViewTransferOutDelegate: NSObjectProtocol {
    func didTransferOutRequest(param: NSDictionary?)
}

class AlertViewTransferOut: UIAlertController {
    weak var delegate: AlertViewTransferOutDelegate? = nil
    fileprivate var amountField: UITextField? = nil
    fileprivate var viewcontroller = UIViewController()
    var gameCode: String = ""
    var alertMessage = AlertMessage()

    fileprivate let margin: CGFloat = 10.0
    fileprivate let width: CGFloat = 272
    fileprivate let height: CGFloat = 50
    fileprivate let defaultFont = UIFont.systemFont(ofSize: 12.0)

    func setUpView() {
        // Add textfield
        self.amountField = UITextField(frame: CGRect(x: margin, y: 0, width: 250, height: 30))
        self.amountField?.placeholder = "转账金额"
        self.amountField?.borderStyle = .bezel
        self.amountField?.font = defaultFont
        self.amountField?.keyboardType = .decimalPad

        // Add textfield to view
        self.viewcontroller.view.addSubview(self.amountField!)
        self.viewcontroller.view.bringSubview(toFront: self.amountField!)
        self.viewcontroller.preferredContentSize = CGSize(width: width, height: height)

        self.setValue(self.viewcontroller, forKey: "contentViewController")
        self.view.tintColor = Alert.globalTint
        let cancel = UIAlertAction(title: alertMessage.cancel, style: .cancel, handler: nil)
        let transfer = UIAlertAction(title: alertMessage.turnOut, style: .default) { (action) in
            self.delegate?.didTransferOutRequest(param: self.getTransferParam())
        }
        self.addAction(transfer)
        self.addAction(cancel)
    }
}

// MARK: - Param builder
extension AlertViewTransferOut {
    func getTransferParam() -> NSDictionary {
        let param = NSDictionary(dictionaryLiteral: ("platform_code", gameCode),
                                 ("amount", amountField?.text ?? ""))
        return param
    }
}
