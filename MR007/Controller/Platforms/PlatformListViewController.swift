//
//  PlatformListViewController.swift
//  MR007
//
//  Created by GreatFeat on 25/04/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// Global Game Code
public enum GameCode: String {
    case PT     = "PT"
    case TTG    = "TTG"
    case BB     = "BB"
    case AG     = "AG"
    case SB     = "SB"
}

class PlatformListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let storyboardView = UIStoryboard(name: "Main", bundle: nil)

    // Data container
    var currentUser: UserModel? = nil
    var platforms = [PlatformModel]()
    var gameType: GameType = .none
    var category = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
    }

    func requestData() {
        let request = PlatformRequestManager()
        request.getPlatformCategory(completionHandler: { (user, platforms) in
            self.currentUser = user
            self.platforms = platforms
            self.tableView.reloadData()

        }, error: { (_error) in

        }, params: NSDictionary(dictionaryLiteral: ("category", category)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GamelistViewController {
            let cell = sender as? PlatformCell
            destination.gameCode = (cell?.currentPlatform?.platformCode)!
            destination.gameType = category
        }
    }
}

extension PlatformListViewController: PlatformCellDelegate {
    func didRefresh(cell: PlatformCell) {

    }

    func didTransferIn(cell: PlatformCell) {
        let transfer = storyboardView.instantiateViewController(withIdentifier: StoryboardId.transfer) as? TransferViewController
        transfer?.type = .transferIn
        transfer?.currentUser = self.currentUser
        transfer?.currentPlatform = cell.currentPlatform
        self.present(transfer!, animated: false, completion: nil)
    }

    func didTransferOut(cell: PlatformCell) {
        let transfer = storyboardView.instantiateViewController(withIdentifier: "Transfer") as? TransferViewController
        transfer?.type = .transferOut
        transfer?.currentUser = self.currentUser
        transfer?.currentPlatform = cell.currentPlatform
        self.present(transfer!, animated: false, completion: nil)
    }

    func didPlay(cell: PlatformCell) {
        self.performSegue(withIdentifier: Segue.gameList, sender: cell)

    }
}

// MARK: - UITableViewDataSource
extension PlatformListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return platforms.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let platformCell = PlatformCell.getCell(tableView: tableView)
        let platform = platforms[indexPath.section]
        platformCell.currentPlatform = platform
        platformCell.gameType = self.gameType
        platformCell.requestData()
        platformCell.delegate = self
        return platformCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - UITableViewDelegate
extension PlatformListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
