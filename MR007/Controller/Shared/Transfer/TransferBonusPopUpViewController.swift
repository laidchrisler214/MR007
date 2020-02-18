//
//  TransferBonusPopUpViewController.swift
//  MR007
//
//  Created by GreatFeat on 27/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

protocol TransferBonusDelegate {
    func transferBonusSelected(bonusId: String, bonusName: String)
}

class TransferBonusPopUpViewController: BaseViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!

    //MARK: - PROPERTIES
    var delegate: TransferBonusDelegate? = nil
    var bonuses = [TransferBonusModel]()
    var platform = String()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.getTransferBonusDetails()
    }

    //MARK: - API
    func getTransferBonusDetails() {
        let request = BonusRequestManager()
        let param = ["platform":self.platform] as NSDictionary
        LoadingView.nativeProgress()
        request.getTransferBonus(completionHandler: { (user, bonuses) in
            LoadingView.hide()
            self.bonuses =  (bonuses as? [TransferBonusModel])!
            self.tableView.reloadData()
        }, error: { (error) in
            LoadingView.hide()
        }, params: param)
    }

    //MARK: - HELPER
    func selectABonus(sender: UIButton) -> Void  {
        self.delegate?.transferBonusSelected(bonusId: String(bonuses[sender.tag].id), bonusName: bonuses[sender.tag].name)
        self.selectedIndex = sender.tag
        self.tableView.reloadData()
    }

}

extension TransferBonusPopUpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bonuses.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferBonusHeaderCell") as? TransferBonusHeaderCell
        cell?.headerButton.addTarget(self, action: #selector(self.removeAnimate), for: UIControlEvents.touchUpInside)
        return cell!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferBonusTableViewCell", for: indexPath) as? TransferBonusTableViewCell
        cell?.buttonOutlet.tag = indexPath.row
        cell?.buttonOutlet.addTarget(self, action: #selector(self.selectABonus), for: UIControlEvents.touchUpInside)
        cell?.set(data: self.bonuses[indexPath.row], index: selectedIndex, currentIndex: indexPath.row)
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

extension TransferBonusPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
