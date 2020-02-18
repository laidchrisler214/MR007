//
//  VIPBonusViewController.swift
//  MR007
//
//  Created by GreatFeat on 09/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class VIPBonusViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bonusNameLabel: UILabel!
    @IBOutlet weak var bonusDetailLabel: UILabel!

    var currentBonus: VIPBonusModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bonusNameLabel.text = currentBonus?.bonusName
        self.bonusDetailLabel.text = "最高奖金额度：¥\(String(describing: currentBonus!.maxBonusMoney))"
    }

    @IBAction func toggleSegmentControll(_ segment: UISegmentedControl) {
        print("State: \(segment)")
    }
    //the confirm and get
    @IBAction func confirmAndClaim () {
        showAccountView()
    }

    func showAccountView() {
        self.saveUserDefault(item: (currentBonus?.bonusId)!, key: Account.selectedBonusId)
        self.saveUserDefault(item: (currentBonus?.bonusName)!, key: Account.selectedBonusName)
        self.tabBarController?.selectedIndex = 1
    }

//    func showConfirmClaim() {
//        let alert = AlertViewTransferIn(title: "救援金", message: nil, preferredStyle: .alert)
//        alert.showBonus = false
//        alert.currentBonus = currentBonus
//        alert.delegate = self
//        alert.setUpView()
//        self.present(alert, animated: true, completion: nil)
//    }
}

// MARK: - AlertViewTransferInDelegate
extension VIPBonusViewController: AlertViewTransferInDelegate {
    func didTransferInRequest(param: NSDictionary?) {
        let request = TransferRequestManager()
        LoadingView.nativeProgress()
        request.requestTransferIn(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.transferBonus, message: response)

        }, error: { (error) in

        }, params: param!)
    }
}

extension VIPBonusViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VIP Bonus Cell", for: indexPath) as? VIPBonusClub
            if indexPath.row == 0 {
                cell?.setBonus(condition: self.currentBonus!)
                return cell!
            } else {
                cell?.setBonus(detail: self.currentBonus!)
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VIPBonusClaim", for: indexPath) as? VIPBonusClaim
            cell?.claimButton.addTarget(self, action: #selector(confirmAndClaim), for: .touchUpInside)
            return cell!
        }
        return UITableViewCell()
    }
}

extension VIPBonusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
