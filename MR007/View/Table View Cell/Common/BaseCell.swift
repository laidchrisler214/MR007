//
//  BaseCell.swift
//  MR007
//
//  Created by Roger Molas on 03/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UITableViewCell {
    enum CellType: String {
        // Account / Balance
        case AccountInfo    = "Account Info Cell"
        case MainWallet     = "Balance Cell"

        // Platforms Cell
        case Platforms      = "Platform Cell"
        case PlatformBalance = "Platform Balance Cell"
        case Transaction    = "Platform Transaction Cell"

        // Deposit
        case Deposit        = "Deposit Method Cell"

        // Withdraw
        case AddBank        = "Add Bank Cell"
        case BankDetails    = "Bank Details Cell"
        case Confirm        = "Confirm Withdrawal Cell"

        // Records
        case Record         = "Record Cell"

        // Message
        case Message        = "Message Cell"
        case Content        = "Message Content Cell"
    }

    @IBOutlet weak var btnRefresh:UIButton!
    var activity: UIActivityIndicatorView? = nil

    func setActivity() {
        var myActivity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.addActivityIndicator(activity: &myActivity)
        self.activity = myActivity
    }

    func requesting() {
        DispatchQueue.main.async {
            self.activity?.startAnimating()
            self.isUserInteractionEnabled = false
        }
    }

    func done() {
        DispatchQueue.main.async {
            self.activity?.stopAnimating()
            self.isUserInteractionEnabled = true
        }
    }
}
