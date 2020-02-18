//
//  AllAnnounceMents.swift
//  Nirvana
//
//  Created by GreatFeat on 01/08/2017.
//  Copyright © 2017 Greatfeat. All rights reserved.
//

import UIKit

class AllAnnounceMents: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var announcements = [NotificationsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 47.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if announcements.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                let indexPath = IndexPath(row: 0, section: self.announcements.count - 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    //MARK: API

}

//MARK: TABLE DATASOURCE AND DELEGATES
extension AllAnnounceMents: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return announcements.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementHeader") as? AnnouncementHeader
        cell?.setCell(announcement: announcements[(announcements.count - 1) - section])
        return cell!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementContent") as? AnnouncementContent
        cell?.setContent(announcement: announcements[(announcements.count - 1) - indexPath.section])
        return cell!
    }
}
