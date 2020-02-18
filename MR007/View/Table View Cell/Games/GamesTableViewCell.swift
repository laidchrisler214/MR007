//
//  GamesTableViewCell.swift
//  MR007
//
//  Created by GreatFeat on 24/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    var urlString = String()
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameBalance: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var turnIn: UIButton!
    @IBOutlet weak var turnOut: UIButton!
    @IBOutlet weak var playButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(platformCode: String, model: GameObjecModel) {
        self.requestBalance(gameCode: platformCode) { (balance) in
            self.gameBalance.text = "¥ \(balance!)"
        }

        if platformCode == "SW" {
            self.urlString = "http://media.mr007.co/images/web/games/web/sw/\(model.gameCode).jpg"
        } else {
            self.urlString = "http://media.mr007.co/images/h5gs_img/\(platformCode)/\(model.gameCode).png"
            print("the game code \(model.gameCode)")
        }
        self.gameImageView.kf.setImage(with: URL(string: self.urlString))
        self.gameLabel.text = model.chineseName
    }

    func requestBalance(gameCode: String, completionHandler: @escaping(_ balance:String?) -> Void) {
        let request = BalanceRequestManager()
        request.getBalance(completionHandler: { (user, wallet) in
            completionHandler(wallet?.balance)
        }, error: nil, param:["platform":gameCode])
    }
}
