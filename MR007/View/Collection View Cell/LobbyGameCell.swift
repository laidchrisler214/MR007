//
//  LobbyGameCell.swift
//  MR007
//
//  Created by GreatFeat on 21/04/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class LobbyGameCell: BaseCollectionCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var gameCode: String = ""
    var imgURL: URL? = nil

    class func getCell(collectionView: UICollectionView, indexPath: IndexPath) -> LobbyGameCell {
        var cell:LobbyGameCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.LobbyGame.rawValue, for: indexPath) as? LobbyGameCell
        if cell == nil {
            cell = LobbyGameCell()
        }
        return cell!
    }

    func setGame(model: LobbyGameModel) {
        self.thumbnail.kf.indicatorType = .activity
        self.thumbnail.kf.setImage(with: URL(string: model.image))
        self.titleLabel.text = model.name
        //self.descLabel.text = model.remark
    }
}
