//
//  BalanceViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 29/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

// Table sections
fileprivate enum TableSection:Int {
    case Account = 0
    case Wallet = 1
    case Platforms = 2
    case Bonus = 3
    case Count = 4
}

class BalanceViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var currentUser: UserModel? = nil
    var platforms = [PlatformModel]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.getAccountBalance()
    }

    func getAccountBalance() {
        let request = AccountRequestManager()
        request.getAccountDetails(completionHandler: { (user, platform) in
            self.currentUser = user
            self.platforms = (platform as? [PlatformModel])!
            self.tableView.reloadData()
        }, error: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Navigate Platform slot with game code (user is logged in)
        if let destination = segue.destination as? SlotViewController {
            let cell = sender as? PlatformCell
            destination.gameCode = (cell?.currentPlatform?.platformCode)!
            destination.headerURL = URL(string: (cell?.currentPlatform?.imageURL)!)
        }
    }
}

extension BalanceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.Count.rawValue
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == TableSection.Wallet.rawValue {
            return tableView.getHeaderHeight()
        }
        if section == TableSection.Platforms.rawValue {
            return tableView.getHeaderHeight()
        }
        return 0.1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TableSection.Wallet.rawValue {
            return Account.AccountBalance
        }
        if section == TableSection.Platforms.rawValue {
            return Account.PlatformBalances
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.Platforms.rawValue {
            return platforms.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableSection.Account.rawValue: // Account Info
            let accountCell = AccountInfoCell.getCell(tableView: tableView)
            accountCell.set(user: self.currentUser) // set data from server
            return accountCell

        case TableSection.Wallet.rawValue: // Wallet Cell
            let walletCell = WalletCell.getCell(tableView: tableView)
            if currentUser != nil {
                walletCell.setWallet(info: (currentUser?.wallet)!)
                walletCell.action = {
                    self.getAccountBalance()
                }
            }
            return walletCell

        case TableSection.Bonus.rawValue: // Get Bonus Cell
            let bonusCell = SingleButtonCell.getCell(tableView: tableView)
            bonusCell.isUserInteractionEnabled = true
            return bonusCell

        default:
            let platformCell = PlatformCell.getCell(tableView: tableView)
            if platforms.count > 0 {
                platformCell.currentPlatform = platforms[indexPath.row]
                platformCell.requestData()
            }
            return platformCell
        }
    }

    @IBAction func rescueBonus () {
        let request = BonusRequestManager()
        LoadingView.nativeProgress()
        request.getRescueBonus(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.rescueBonus, message: response)

        }) { (error) in

        }
    }
}

extension BalanceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TableSection.Account.rawValue {
            return AccountInfoCell.height
        }

        if indexPath.section == TableSection.Wallet.rawValue {
            return WalletCell.height
        }

        if indexPath.section == TableSection.Bonus.rawValue {
            return UITableViewCell.buttonCellHeight
        }
        return UITableViewCell.defaultCellHeight // Default height
    }
}
