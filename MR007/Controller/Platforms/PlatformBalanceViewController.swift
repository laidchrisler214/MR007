//
//  PlatformBalanceViewController.swift
//  MR007
//
//  Created by GreatFeat on 26/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class PlatformBalanceViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var platformTitle: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    var currentPlatform: PlatformModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "\(currentPlatform.platformCode)馆"
        self.platformTitle.text = "\(currentPlatform.platformCode)馆账户余额（¥）"
        getBalance()
    }

    func getBalance() {
        requestBalance(gameCode: currentPlatform.platformCode) { (balance) in
            self.balanceLabel.text = "¥\(balance!)"
        }
    }

    func requestBalance(gameCode: String, completionHandler: @escaping(_ balance:String?) -> Void) {
        let request = BalanceRequestManager()
        request.getBalance(completionHandler: { (user, wallet) in
           completionHandler(wallet?.balance)
        }, error: { (error) in
        }, param:["platform":gameCode])
    }

    func getRebate() {
        let sharedUser = SharedUserInfo.sharedInstance

        LoadingView.nativeProgress()
        let request = RebateRequestManager()
        request.requestForRebate(completionHandler: { (user, response) in
            LoadingView.hide()
            let isSuccess = response?["success"] as? Bool
            Answers.logCustomEvent(withName: "Get Rebate", customAttributes: [ "user": sharedUser.getUserName(), "rebate_isSuccess": String(describing: isSuccess)])
            if isSuccess! {
                Alert.with(title: self.alertMessage.success, message: response?["success"] as? String)
            }
        }, error: { (error) in
            LoadingView.hide()
        }, params: ["platform": currentPlatform.platformCode])
    }

    //MARK: HELPER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlatformGamesListViewController {
            destination.platformCode = currentPlatform.platformCode
        }
    }
}

extension PlatformBalanceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentPlatform.platformCode == "PT" || currentPlatform.platformCode == "TTG" || currentPlatform.platformCode == "SW" {
            return 3
        }
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlatformBalanceCell.getCell(tableView: tableView, index: indexPath, platform: currentPlatform.platformCode)
        return cell
    }
}

extension PlatformBalanceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if let popOverVC:TransferInPopUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransferInPopUpViewController") as? TransferInPopUpViewController {
                    popOverVC.platformCode = currentPlatform.platformCode
                    popOverVC.platformName = currentPlatform.longName
                    popOverVC.delegate = self
                    self.addChildViewController(popOverVC)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                }
            } else {
                if let popOverVC:TransferOutViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransferOutViewController") as? TransferOutViewController {
                    popOverVC.platformCode = currentPlatform.platformCode
                    popOverVC.platformName = currentPlatform.longName
                    popOverVC.delegate = self
                    self.addChildViewController(popOverVC)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                }
            }
        } else if indexPath.section == 1 {
            self.getRebate()
        } else if indexPath.section == 2 {
            if currentPlatform.platformCode == "SW" || currentPlatform.platformCode == "PT" || currentPlatform.platformCode == "TTG" {
                performSegue(withIdentifier: "segueToGames", sender: self)
            }
        }
    }
}

extension PlatformBalanceViewController: TransferOutDelegate {
    func transferOutComplete(newBalance: String) {
        self.balanceLabel.text = "¥\(newBalance)"
    }
}

extension PlatformBalanceViewController: TransferInDelegate {
    func transferInComplete(newBalance: String) {
        self.balanceLabel.text = "¥\(newBalance)"
    }
}


