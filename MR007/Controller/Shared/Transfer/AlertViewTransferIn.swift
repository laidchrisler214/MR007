//
//  AlertViewTransferIn.swift
//  MR007
//
//  Created by Roger Molas on 13/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

protocol AlertViewTransferInDelegate: NSObjectProtocol {
    func didTransferInRequest(param: NSDictionary?)
}

class AlertViewTransferIn: UIAlertController {
    weak var delegate: AlertViewTransferInDelegate? = nil
    var contents = [BaseBonusModel]()
    var currentBonus: BaseBonusModel? = nil
    var gameCode: String = ""
    var showBonus: Bool = true

    fileprivate var tableView: UITableView? = nil
    fileprivate var amountField: UITextField? = nil
    fileprivate var bonusField: UITextField? = nil
    fileprivate var activityIndicator: UIActivityIndicatorView? = nil
    fileprivate var viewcontroller = UIViewController()

    fileprivate let margin: CGFloat = 10.0
    fileprivate let width: CGFloat = 272
    fileprivate let height: CGFloat = 80
    fileprivate let defaultFont = UIFont.systemFont(ofSize: 12.0)

    func setUpView() {
        // Add textfield
        self.amountField = UITextField(frame: CGRect(x: margin, y: 0, width: 250, height: 30))
        self.amountField?.placeholder = "转账金额"
        self.amountField?.borderStyle = .bezel
        self.amountField?.font = defaultFont
        self.amountField?.keyboardType = .decimalPad
        self.amountField?.tag = 1
        self.amountField?.delegate = self

        // Add textfield to view
        self.viewcontroller.view.addSubview(self.amountField!)
        self.viewcontroller.view.bringSubview(toFront: self.amountField!)

        if showBonus {
            self.bonusField = UITextField(frame: CGRect(x: margin, y: (self.amountField?.frame.maxY)! + margin, width: 250, height: 30))
            self.bonusField?.placeholder = "Transfer bunos"
            self.bonusField?.borderStyle = .bezel
            self.bonusField?.font = defaultFont
            self.bonusField?.tag = 2
            self.bonusField?.delegate = self
            self.bonusField?.isEnabled = false

            self.viewcontroller.view.addSubview(self.bonusField!)
            self.viewcontroller.view.bringSubview(toFront: self.bonusField!)
            self.tableView?.isHidden = true

            // Add Activity indicator view
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.activityIndicator?.startAnimating()
            self.activityIndicator?.hidesWhenStopped = true
            self.viewcontroller.view.addSubview(self.activityIndicator!)
            self.activityIndicator?.center = CGPoint(x: (self.bonusField?.frame.midX)!, y: (self.bonusField?.frame.midY)!)
            self.requestBonus()

        } else {
            self.viewcontroller.preferredContentSize = CGSize(width: width, height: 50)
        }

        self.setValue(self.viewcontroller, forKey: "contentViewController")
        self.view.tintColor = Alert.globalTint
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let transfer = UIAlertAction(title: "转入", style: .default) { (action) in
            self.delegate?.didTransferInRequest(param: self.getTransferParam())
        }
        self.addAction(transfer)
        self.addAction(cancel)
    }

    func hideTable() {
        self.tableView?.isHidden = true
        self.viewcontroller.preferredContentSize = CGSize(width: width, height: height)
    }

    func showTable() {
        self.tableView = UITableView(frame: self.tableExpectedSize())
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.allowsSelection = true
        self.tableView?.isUserInteractionEnabled = true
        self.tableView?.backgroundColor = UIColor.clear

        // Add table view to view
        self.viewcontroller.view.isUserInteractionEnabled = true
        self.viewcontroller.view.addSubview(self.tableView!)
        self.viewcontroller.view.bringSubview(toFront: self.tableView!)
        let expectedHeight = self.tableExpectedSize().size.height + height
        self.viewcontroller.preferredContentSize = CGSize(width: width, height: expectedHeight)
    }

    func tableExpectedSize() -> CGRect {
        var rect = CGRect.zero
        let tableWidth :CGFloat = 250.0
        let originX = margin
        let originY = (self.bonusField?.frame.maxY)!

        if contents.count < 4 {
            rect = CGRect(x: originX, y: originY, width: tableWidth, height: 100.0)

        } else if contents.count < 6 {
            rect = CGRect(x: originX, y: originY, width: tableWidth, height: 150.0)

        } else if contents.count < 8 {
            rect = CGRect(x: originX, y: originY, width: tableWidth, height: 180.0)

        } else {
            rect = CGRect(x: originX, y: originY, width: tableWidth, height: 210.0)
        }
        return rect
    }

    // MARK: - Bonus API Request
    func requestBonus() {
        let request = BonusRequestManager()
        request.getTransferBonus(completionHandler: { (user, bonusList) in
            self.contents = (bonusList as? [BaseBonusModel])!
            self.tableView?.reloadData()
            self.activityIndicator?.stopAnimating()
            self.bonusField?.isEnabled = true

        }, error: { (error) in

        }, params: ["platform":gameCode])
    }
}

// MARK: - UITextFieldDelegate
extension AlertViewTransferIn: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            self.showTable()
            return
        }

        if showBonus {
            self.hideTable()
        }
    }
}

// MARK: - UITableViewDataSource
extension AlertViewTransferIn: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell()
        }
        let bonus = contents[indexPath.row]
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.font = defaultFont
        cell?.textLabel?.text = "\(bonus.name)"
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension AlertViewTransferIn: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bonus = contents[indexPath.row]
        self.bonusField?.text = bonus.name
        self.amountField?.becomeFirstResponder()
        self.currentBonus = bonus
        self.hideTable()
    }
}

// MARK: - Param builder
extension AlertViewTransferIn {
    func getTransferParam() -> NSDictionary {
        var param: NSDictionary? = nil
        if showBonus { /// Transfer from account
            param = NSDictionary(dictionaryLiteral: ("platform_code", gameCode),
                                 ("bonus_id", currentBonus?.bonusId ?? ""),
                                 ("amount", amountField?.text ?? ""))
        } else {
           // let gameId = String(describing: currentBonus!.gameId)
            let vipBonusId = String(describing: currentBonus!.vipBonusId)
            param = NSDictionary(dictionaryLiteral: ("platform_code", "PT") /*("game_id", gameId) */,
                                 ("bonus_id", vipBonusId),
                                 ("amount", amountField?.text ?? ""))
        }
        return param!
    }
}
