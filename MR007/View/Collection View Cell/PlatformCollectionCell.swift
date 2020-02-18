//
//  PlatformCollectionCell.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

import UIKit

class PlatformCollectionCell: BaseCollectionCell {
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    var currentPlatform: BaseGameModel? = nil
    var platform = ""

    class func getCell(collectionView: UICollectionView, indexPath: IndexPath) -> PlatformCollectionCell {
        var cell:PlatformCollectionCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.Game.rawValue, for: indexPath)  as? PlatformCollectionCell
        if cell == nil {
            cell = PlatformCollectionCell()
        }
        return cell!
    }

    func set(game: BaseGameModel) {
        self.lblTitle.text = game.gameName
        self.thumbnail.kf.indicatorType = .activity
        self.thumbnail.kf.setImage(with:URL(string: game.imageURL))
        self.currentPlatform = game // reference current game model
    }

    func launchGame() {
        let user = SharedUserInfo.sharedInstance
        if  !user.isLogIn() {
            Alert.with(title: "Ooop!", message: "Please login to play the game")
            return
        }
        let request = LaunchGameRequestManager()
        request.launchExternalRequest(param: getGameParam(), platform: platform)
    }

    func getGameParam() -> NSDictionary {
        let param = NSDictionary(dictionaryLiteral:("gameId", currentPlatform?.gameId ?? ""),
                                 ("gameCode", currentPlatform?.gameCode ?? ""),
                                 ("gameType", currentPlatform?.gameType ?? ""),
                                 ("sig", URLBuilder.getXAuthToken()))
        return param
    }
}

class ListViewHeaderView: UICollectionReusableView {
    @IBOutlet weak var label:UILabel!

    class func getHeaderView(collectionView: UICollectionView, indexPath: IndexPath) -> ListViewHeaderView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                           withReuseIdentifier: "Header View",
                                                                           for: indexPath) as? ListViewHeaderView
        reusableView?.label.text = "TOP GAMES"
        return reusableView!
    }
}
