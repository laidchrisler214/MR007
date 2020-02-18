//
//  AccountViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 28/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

fileprivate struct Rows {
    static let profile        = 0
    static let transaction    = 1

    static let balance        = 0
    static let platform       = 1

    static let rescue         = 0
    static let logs           = 1
}

fileprivate enum Cell: String {
    case profile        = "Profile Cell"
    case transaction    = "Transaction Cell"
    case balance        = "Balance Cell"
    case platform       = "Platform Cell"
    case rescue         = "Rescue Bonus Cell"
    case logs           = "Transaction Logs Cell"
}

class AccountViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UIBarButtonItem!

    var currentUser: UserModel? = nil
    var platforms = [PlatformModel]()
    var bankCount = Int()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = CGRect.zero
        frame.size.height = 1
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.setNavigationBarItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAccountBalance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setRightNavigationItem()
    }

    func getAccountBalance() {
        let request = AccountRequestManager()
        LoadingView.nativeProgress()
        request.getAccountDetails(completionHandler: { (user, platforms) in
            LoadingView.hide()
            self.currentUser = user
            self.platforms = platforms
            self.sortPlatforms()
            self.requestBankList()
        }) { (error) in
            LoadingView.hide()
        }
    }

    func requestBankList() {
        let request = WithdrawalRequestManager()
        request.requestBankList(completionHandler: { (user, bankList) in
            LoadingView.hide()
            self.bankCount = (bankList?.count)!
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }

//    func refreshAccountBalanceInfo(sender: UIButton) -> Void {
//        getAccountBalance()
//    }

    @IBAction func rescueBonusAction(_ sender: Any) {
        let request = BonusRequestManager()
        LoadingView.nativeProgress()
        request.getRescueBonus(completionHandler: { (user, response) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Claim Rescue Bonus", customAttributes: ["user": user?.loginName ?? "", "email": user?.email ?? "", "lastLogInIp": user?.lastLogInIp ?? "", "balance": user?.balance ?? "", "response": response ?? "" ])
            Alert.with(title: self.alertMessage.rescueBonus, message: response)
        }) { (error) in
            LoadingView.hide()
        }
    }

    func setRightNavigationItemTitle() {
        userName.title = currentUser?.fullName
    }

    func sortPlatforms() {
        let temp = platforms[4]
        for i in stride(from:platforms.count - 3, to: 1, by: -1 ) {
            platforms[i] = platforms[i-1]
        }
        platforms[1] = temp
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlatformBalanceViewController {
            let platform = self.platforms[self.selectedIndex]
            destination.currentPlatform = platform
        }
    }
}

extension AccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return platforms.count - 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceHeaderCell") as? BalanceHeaderCell
            if self.currentUser != nil {
                self.saveUserDefault(item: currentUser?.balance ?? "", key: Account.accountBalanceRecord)
                cell?.set(user: self.currentUser!)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformHeaderCell") as? PlatformHeaderCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankCardsCell", for: indexPath) as? BankCardsCell
            cell?.setCell(bankCount: self.bankCount)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformListCell", for: indexPath) as? PlatformListCell
            cell?.set(platforms: platforms[indexPath.row], index: indexPath.row)
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 93
        } else {
            return 60
        }
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "segueToBankList", sender: self)
        } else {
            if platforms[indexPath.row].longName != "SW" {
                self.selectedIndex = indexPath.row
                self.performSegue(withIdentifier: "segueToPlatformBalance", sender: self)
            }
        }
    }
}

