//
//  GameCell.swift
//  MR007
//
//  Created by GreatFeat on 25/04/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

protocol GameCellDelegate: NSObjectProtocol {
    func didPlay(cell:GameCell)
}

class GameCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!

    var imgURL: URL? = nil
    var currentGame: GameObjecModel? = nil
    var platform = ""

    weak var delegate: GameCellDelegate? = nil

    class func getCell(tableView: UITableView, indexPath: IndexPath) -> GameCell {
        var cell: GameCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: indexPath) as? GameCell
        if cell == nil {
            cell = GameCell() // Set data from server
        }
        return cell!
    }

    func set(game: GameObjecModel) {
        self.titleLabel.text = game.englishName
        self.descLabel.text = game.englishName
        self.thumbnailImage.kf.indicatorType = .activity
        self.thumbnailImage.kf.setImage(with:URL(string: game.imageURL))
        self.currentGame = game
        self.playButton.addTarget(self, action: #selector(GameCell.launchGame), for: .touchUpInside)
    }

    func launchGame() {
        let user = SharedUserInfo.sharedInstance
        if !user.isLogIn() {
            Alert.with(title: "Ooop!", message: "Please login to play the game")
            return
        }

        if self.platform == "PT" {
            launchPTGame()
        }

        if self.platform == "TTG" {
            launchTTGGame()
        }
    }

    func launchPTGame() {
        let request = LaunchGameRequestManager()
        request.launchExternalRequest(param: getGameParam(), platform: platform.lowercased())
    }

    func launchTTGGame() {
        let gameId = currentGame?.gameId
        let request = LaunchGameRequestManager()
        request.launchTTGGame(completionHandler: { (user, url) in
            let url = URL(string: url!)
            UIApplication.shared.open(url!, options: ["launch":"game"], completionHandler: nil)

        }, error: { (error) in

        }, param: NSDictionary(dictionaryLiteral: ("gameId", "\(gameId!)")))
    }

    func getGameParam() -> NSDictionary {
        let param = NSDictionary(dictionaryLiteral: ("gameCode", currentGame?.gameCode ?? ""),
                                 ("sig", URLBuilder.getXAuthToken()))
        return param
    }
}
