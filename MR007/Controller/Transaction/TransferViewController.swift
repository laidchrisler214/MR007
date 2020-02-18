//
//  TransferViewController.swift
//  MR007
//
//  Created by GreatFeat on 26/04/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

public enum TransferType {
    case none
    case transferIn
    case transferOut
}

public enum TransferMode: String {
    case In  = "Transfer IN"
    case Out = "Transfer OUT"
}

class TransferViewController: UIViewController {
    @IBOutlet weak var titleItem: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bonusView: UIView!

    @IBOutlet weak var accountBalanceView: UIView!
    @IBOutlet weak var platformBalanceView: UIView!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    @IBOutlet weak var platformBalanceLabel: UILabel!
    @IBOutlet weak var amountField: AmountLabel!

    // Logic
    var cursorView: UIView? = nil
    var type: TransferType = TransferType.none
    var isTransferIN: Bool = true
    var showBonus: Bool = true

    // Data containers
    var currentUser: UserModel? = nil
    var currentBonus: BaseBonusModel? = nil
    var currentPlatform: PlatformModel? = nil
    var gameCode: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial rect
        var rect = self.containerView.frame
        rect.origin.y = rect.maxY
        containerView.frame = rect

        // Set transaction data
        self.accountBalanceLabel.text = self.currentUser?.balance
        self.platformBalanceLabel.text = self.currentPlatform?.balance

        self.amountField.backgroundColor = UIColor.white
        self.amountField.layer.borderColor = UIColor.white.cgColor
        self.amountField.isUserInteractionEnabled = true
        self.amountField.text = " Amount"
        self.amountField.textColor = UIColor.lightGray
        self.amountField.layer.borderWidth = 1.0
        self.amountField.layer.cornerRadius = 2.0
        self.amountField.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action:#selector(TransferViewController.handleTapAmountField(recognizer:))))
    }

    func handleTapAmountField(recognizer: UITapGestureRecognizer) {
        if self.cursorView == nil {
            self.amountField.textColor = UIColor.black
            self.amountField.text = "¥ "
            let height = self.amountField.frame.height - 10
            let rect = CGRect(x: positionX(), y: 5, width: 2, height: height)
            self.cursorView = UIView(frame: rect)
            self.cursorView?.backgroundColor = UIColor.gray
            self.amountField.addSubview(cursorView!)

            UIView.animate(withDuration: 1.0, delay: 0, options: .repeat, animations: {
                self.cursorView?.alpha = 0.1
            }, completion: { (flag) in
                self.cursorView?.alpha = 1.0
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var rect = self.containerView.frame
        UIView.animate(withDuration: 0.25, animations: {
            rect.origin.y -= rect.size.height
            self.containerView.frame = rect

        }) { (flag) in
            self.setUpView(type: self.type)
        }
    }

    // View layout
    func setUpView(type: TransferType) {
        if self.type == .transferIn {
            self.isTransferIN = true
            self.titleItem.title =  TransferMode.In.rawValue
            self.bonusView.isHidden = false
        } else if self.type == .transferOut {
            self.titleItem.title =  TransferMode.Out.rawValue
            self.swap(triger: true)
            self.bonusView.isHidden = true
        }
    }

    @IBAction func swap(triger: Bool) {
        var rect1 = accountBalanceView.frame
        var rect2 = platformBalanceView.frame
        UIView.animate(withDuration: 0.25, animations: {
            rect1.origin.y = rect1.origin.y
            rect2.origin.y = rect2.origin.y
            self.accountBalanceView.frame = rect2
            self.platformBalanceView.frame = rect1

            if !triger {
                self.isTransferIN = !self.isTransferIN
                self.titleItem.title = (self.isTransferIN) ? TransferMode.In.rawValue : TransferMode.Out.rawValue
                if self.isTransferIN {
                    self.type = .transferIn
                } else {
                    self.type = .transferOut
                }
            }
            self.bonusView.isHidden = !self.bonusView.isHidden
        }) { (flag) in

        }
    }

    func dismiss() {
        var rect = self.containerView.frame
        UIView.animate(withDuration: 0.25, animations: {
            rect.origin.y = rect.maxY
            self.containerView.frame = rect
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func cancelAction() {
        self.dismiss()
    }

    @IBAction func doneAction() {
        self.dismiss()
    }

    @IBAction func confirm() {
        if self.type == .transferIn {
            self.sendTransferInRequest(param: self.transferInParam())
        }

        if self.type == .transferOut {
            self.sendTransferOutRequest(param: self.transferOutParam())
        }
    }

    /// Request updated balance (TEMP) will add to response later
    func requestUpdatedData() {
        let request = PlatformRequestManager()
        request.getPlatformDetails(completionHandler: { (user, platfrom: PlatformModel) in
            self.currentPlatform = platfrom
            self.requestUserBalance()  // TMP
        }, error: { (_error) in
            LoadingView.hide()

        }, params: NSDictionary(object: currentPlatform?.platformCode ?? "", forKey: "platform" as NSCopying))
    }

    func requestUserBalance() {
        let request = AccountRequestManager()
        request.getAccountDetails(completionHandler: { (user, platforms) in
            self.currentUser = user
            LoadingView.success {
                self.updateView(response: nil)
            }
        }) { (error) in
            LoadingView.hide()
        }
    }

    /// Send Transfer In Request
    func sendTransferInRequest(param: NSDictionary) {
        LoadingView.nativeProgress()
        let request = TransferRequestManager()
        request.requestTransferIn(completionHandler: { (user, response) in
            self.requestUpdatedData() // TMP
        }, error: { (error) in
            LoadingView.hide()

        }, params: param)
    }

    /// Send Transfer Out Request
    func sendTransferOutRequest(param: NSDictionary) {
        LoadingView.nativeProgress()
        let request = TransferRequestManager()
        request.requestTransferOut(completionHandler: { (user, response) in
            self.requestUpdatedData() // TMP
        }, error: { (error) in
            LoadingView.hide()

        }, params: param)
    }

    /// Update view after transactions
    func updateView(response: String?) {
        self.amountField.text = ""
        // Set transaction data
        self.accountBalanceLabel.text = self.currentUser?.balance
        self.platformBalanceLabel.text = self.currentPlatform?.balance

    }
}

// Keyboard press
extension TransferViewController {
    @IBAction func keyPress(_ button: UIButton) {
        self.amountField.text?.append((button.titleLabel?.text)!)
        self.cursorView?.frame.origin.x = self.positionX()
    }

    @IBAction func returnPress(_ button: UIButton) {

    }

    @IBAction func backspcePress(_ button: UIButton) {
        var text = self.amountField.text
        if (text?.characters.count)! > 0 {
            let index = text?.characters.endIndex
            self.amountField.text = text?.substring(to: (text?.characters.index(index!, offsetBy: -1))!)
            self.cursorView?.frame.origin.x = self.positionX()
        }
    }
}

extension TransferViewController {
    func transferInParam() -> NSDictionary {
        let platformCode = (currentPlatform?.platformCode)!
        let amount = amountField?.text ?? ""
        var bonus = ""

        if showBonus {
            bonus = currentBonus?.bonusId ?? ""
        } else {
            bonus = String(describing: currentBonus!.vipBonusId)
        }

        let param = NSDictionary(dictionaryLiteral: ("platform_code", platformCode),
                                 ("bonus_id", bonus),
                                 ("amount", amount))
        return param
    }

    func transferOutParam() -> NSDictionary {
        let platformCode = (currentPlatform?.platformCode)!
        let amount = amountField?.text ?? ""
        let param = NSDictionary(dictionaryLiteral: ("platform_code", platformCode),
                                 ("amount", amount))
        return param
    }

    func positionX() -> CGFloat {
        let textSize: CGSize = self.amountField.text!.size(attributes: [NSFontAttributeName:self.amountField.font])
        return textSize.width + 5
    }
}
