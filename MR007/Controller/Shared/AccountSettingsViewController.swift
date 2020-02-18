//
//  AccountSettingsViewController.swift
//  MR007
//
//  Created by Roger Molas on 03/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Cell:String {
    case Normal = "Normal Cell"
    case Custom = "Custom Cell"
}

class AccountSettingsViewController: MRViewController {
    @IBOutlet weak var tableview: UITableView!
    var user: UserModel? = nil

    var isToggleSideBar: Bool = false
    let section1 = ["My avatar", "Account name", "VIP level", "My debit card"]
    let section2 = ["ID card name", "Birth", "Email", "Cell phone number"]
    let section3 = ["Password"]
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isToggleSideBar {
            self.setNavigationBarItem()
        }

        self.user = UserModel()
        let info = SharedUserInfo.sharedInstance.getUserDetails()
        self.user?.setUser(info: info)
    }
}

extension AccountSettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1.count
        }
        if section == 1 {
            return section2.count
        }
        return section3.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:SettingCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: Cell.Normal.rawValue, for: indexPath) as? SettingCell
        if indexPath.section == 0 {
            cell?.titleLabel?.text = section1[indexPath.row]
        }

        if indexPath.section == 1 {
            cell?.titleLabel?.text = section2[indexPath.row]
        }

        if indexPath.section == 2 {
            cell?.titleLabel?.text = section3[indexPath.row]
        }
        return cell!
    }
}

extension AccountSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settings = storyBoard.instantiateViewController(withIdentifier: StoryboardId.avatar)
            self.navigationController?.pushViewController(settings, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewCell.defaultCellHeight // Default height
    }
}
