//
//  PlatformListCell.swift
//  MR007
//
//  Created by GreatFeat on 04/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class PlatformListCell: UITableViewCell {

    @IBOutlet weak var refreshImage: UIImageView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var platformRefreshButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var platformIcon: UIImageView!

    let user = SharedUserInfo.sharedInstance
    private var currentPlatform:PlatformModel? = nil
    var platformIconArray = [#imageLiteral(resourceName: "platPT"), #imageLiteral(resourceName: "platNewPt"), #imageLiteral(resourceName: "platTTG"), #imageLiteral(resourceName: "platAG"), #imageLiteral(resourceName: "platGG"), #imageLiteral(resourceName: "platSB")]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.platformRefreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(platforms: PlatformModel, index: Int) {
        self.requesting()
        self.currentPlatform = platforms
        initialsLabel.backgroundColor = getColor(index: index)
        self.platformIcon.image = platformIconArray[index]
        initialsLabel.text = platforms.longName[0]
        self.balanceLabel.text = "载入中"
        var longName = platforms.longName
        if longName == "GG" {
            longName = "GG馆"
        } else if longName == "SW" {
            longName = "全新PT"
            getAccountBalance()
        }
        nameLabel.text = longName
        if longName != "全新PT" {
            requestBalance(gameCode: platforms.platformCode) { (balance) in
                self.refreshImage.isHidden = false
                self.balanceLabel.text = "¥ \(balance!)"
                self.done()
            }
        }
    }

    func requestBalance(gameCode: String, completionHandler: @escaping(_ balance:String?) -> Void) {
        let request = BalanceRequestManager()
        refreshImage.isHidden = true
        request.getBalance(completionHandler: { (user, wallet) in
            completionHandler(wallet?.balance)
        }, error: { (error) in
        }, param:["platform":gameCode])

    }

    func getAccountBalance() {
        let request = AccountRequestManager()
        refreshImage.isHidden = true
        let sharedUser = SharedUserInfo.sharedInstance
        request.getAccountDetails(completionHandler: { (user, platforms) in
            LoadingView.hide()
            var balance = Double(sharedUser.getUserMainBalance())
            balance = round(1000 * balance!) / 1000
            self.refreshImage.isHidden = false
            self.balanceLabel.text = String(format: "¥ %.2f", balance!)
            self.done()
        }) { (error) in
            LoadingView.hide()
            self.refreshImage.isHidden = false
            self.balanceLabel.text = "系统维护中"
            self.done()
        }
    }

    @objc private func refreshAction () {
        initialsLabel.text = self.currentPlatform?.longName[0]
        self.balanceLabel.text = "载入中"
        var longName = self.currentPlatform?.longName
        if longName == "GG" {
            longName = "GG馆"
        } else if longName == "SW" {
            longName = "全新PT"
            self.requesting()
            getAccountBalance()
        }
        nameLabel.text = longName
        if longName != "全新PT" {
            self.requesting()
            requestBalance(gameCode: (self.currentPlatform?.platformCode)!) { (balance) in
                self.done()
                self.refreshImage.isHidden = false
                self.balanceLabel.text = "¥ \(balance!)"
            }
        }
    }

    func getColor(index: Int) -> UIColor {
        var hexColors = [0x417DC4, 0xDF9418, 0xD0021B, 0xF58023, 0x002950, 0x417505]
        let hex = HexColorConverter()
        return hex.UIColorFromHex(hexValue: UInt32(hexColors[index]))
    }

    func requesting() {
        DispatchQueue.main.async {
            self.activity.startAnimating()
            self.activity.isHidden = false
            self.isUserInteractionEnabled = false
        }
    }

    func done() {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.isUserInteractionEnabled = true
        }
    }
}
