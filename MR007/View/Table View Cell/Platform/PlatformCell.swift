//
//  PlatformCell.swift
//  MR007
//
//  Created by Roger Molas on 03/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

public enum GameType: String {
    case slot   = "Slot Games"
    case casino = "Casino Games"
    case sport  = "Sportbook Games"
    case fish   = "Fish Games"
    case none   = "No Games"

    enum Category: String {
        case slot   = "1"
        case casino = "2"
        case sport  = "3"
        case fish   = "4"
        case none   = "5"
    }
}

protocol PlatformCellDelegate: NSObjectProtocol {
    func didRefresh(cell: PlatformCell)
    func didTransferIn(cell: PlatformCell)
    func didTransferOut(cell: PlatformCell)
    func didPlay(cell: PlatformCell)
}

class PlatformCell: BaseCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var platformTitleLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    var imgURL: URL? = nil
    var isAccountPage: Bool = false

    weak var delegate: PlatformCellDelegate? = nil
    var currentPlatform: PlatformModel? = nil
    var gameType: GameType = .none

    class func getCell(tableView: UITableView) -> PlatformCell {
        var platformCell: PlatformCell?
        platformCell = tableView.dequeueReusableCell(withIdentifier: CellType.Platforms.rawValue) as? PlatformCell
        if platformCell == nil {
            platformCell = PlatformCell() // Set data from server
        }
        platformCell?.setActivity()
        return platformCell!
    }

    override func requesting() {
        super.requesting()
        if isAccountPage {
            self.requestAccountData() // request from account page
        }
        self.requestData() // Request task
    }

    @IBAction func refresh() {
        delegate?.didRefresh(cell: self)
    }

    @IBAction func transferIn() {
        delegate?.didTransferIn(cell: self)
    }

    @IBAction func transferOut() {
        delegate?.didTransferOut(cell: self)
    }

    @IBAction func playGame() {
        delegate?.didPlay(cell: self)
    }

    /// Invoke when user go to category page
    func requestData() {
        self.balanceLabel.text = "Loading ..."
        self.platformTitleLabel.text = ""
        self.platformLabel.text = ""

        let request = PlatformRequestManager()
        request.getPlatformDetails(completionHandler: { (user, platfrom: PlatformModel) in
            // API
            self.balanceLabel.text = platfrom.details
            self.platformLabel.text = self.currentPlatform?.platformCode
            self.done()

            // local
            self.currentPlatform?.balance = platfrom.balance
            self.currentPlatform?.details = platfrom.details

            switch self.gameType {
            case .slot:
                self.platformTitleLabel.text = "\((self.currentPlatform?.platformCode)!) \(GameType.slot.rawValue)"
            case .casino:
                self.platformTitleLabel.text = "\((self.currentPlatform?.platformCode)!) \(GameType.casino.rawValue)"
            case .sport:
                self.platformTitleLabel.text = "\((self.currentPlatform?.platformCode)!) \(GameType.sport.rawValue)"
            case .fish:
                self.platformTitleLabel.text = "\((self.currentPlatform?.platformCode)!) \(GameType.fish.rawValue)"
            default: break

            }

        }, error: { (_error) in
            self.textLabel?.text = "Failed"

        }, params: NSDictionary(object: currentPlatform?.platformCode ?? "", forKey: "platform" as NSCopying))
    }

    /// invoke when user goto to account page
    func requestAccountData() {
        self.balanceLabel.text = "Loading ..."
        self.platformTitleLabel.text = ""
        self.platformLabel.text = ""

        let request = PlatformRequestManager()
        request.getPlatformDetails(completionHandler: { (user, platfrom: PlatformModel) in
            // API
            self.balanceLabel.text = platfrom.details
            self.platformLabel.text = self.currentPlatform?.platformCode
            self.done()

            // local
            self.currentPlatform?.balance = platfrom.balance
            self.currentPlatform?.details = platfrom.details
            self.platformTitleLabel.text = "\((self.currentPlatform?.platformCode)!) Wallet"

        }, error: { (_error) in
            self.textLabel?.text = "Failed"

        }, params: NSDictionary(object: currentPlatform?.platformCode ?? "", forKey: "platform" as NSCopying))
    }
}
