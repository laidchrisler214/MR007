//
//  CooperationViewController.swift
//  MR007
//
//  Created by GreatFeat on 19/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class CooperationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var shouldExpand = [Bool]()
    var heightArray = [0, 700, 550, 330, 250]

    override func viewDidLoad() {
        super.viewDidLoad()
        fillBooleanArray()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.removeUserDefault(key: Segue.segueFromMenu)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.tabBarController?.tabBar.isHidden = false
    }

    func fillBooleanArray() {
        shouldExpand.removeAll()
        for _ in 0..<5 {
            shouldExpand.append(false)
        }
    }

    func updateBooleanArray(index: Int) {
        for i in 0..<5 {
            if shouldExpand[i] == true && index == i {
                shouldExpand[i] = false
            } else if shouldExpand[i] == false && index == i {
                shouldExpand[i] = true
            } else {
                shouldExpand[i] = false
            }
        }
    }

    func expandRow(sender: UIButton) -> Void {
        updateBooleanArray(index: sender.tag)
        tableView.reloadData()
    }
}

extension CooperationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CooperationHeaderCell") as? CooperationHeaderCell
            return cell
        } else if section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CooperationContentCell") as? CooperationContentCell
            cell?.setCell(index: section - 1, expanded: shouldExpand[section])
            cell?.expandButton.tag = section
            cell?.expandButton.addTarget(self, action: #selector(expandRow), for: UIControlEvents.touchUpInside)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell", for: indexPath) as? WebViewCell
            cell?.setWebView(index: indexPath.section - 1)
            return cell!
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 0 {
            if shouldExpand[indexPath.section] {
                return CGFloat(heightArray[indexPath.section])
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 74
        } else {
            if shouldExpand[section] {
                return 121
            } else {
                return 129
            }
        }
    }
}

extension CooperationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
