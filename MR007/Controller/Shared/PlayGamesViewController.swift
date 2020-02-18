//
//  PlayGamesViewController.swift
//  MR007
//
//  Created by Roger Molas on 02/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// CollectionView Tag
fileprivate enum ListView: Int {
    case Menu = 100
    case List = 200
}

class PlayGamesViewController: MRViewController {
    @IBOutlet weak var listMenuView:UICollectionView!
    @IBOutlet weak var listItemView:UICollectionView!

    fileprivate let category = ["Game 1", "Game 2", "Game 3", "Game 4", "Game 5", "Game 6", "Game 7"]
    fileprivate let fixList = ["Game 1", "Game 2", "Game 3", "Game 4", "Game 5", "Game 6", "Game 7"] // For debugging
    var itemList = [BaseGameModel]()

    var platformType: String = "" // Pass platform for launching game
    var gameCode: String = "" // if user is not logged in

    override func viewDidLoad() {
        self.listItemView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        /// If user is not logged in
        getGameInfo()
    }

    func getGameInfo() {
        if gameCode == GameCode.PT.rawValue {
            requestPTGames()
            return
        }
        if gameCode == GameCode.TTG.rawValue {
            requestTTGGames()
            return
        }
        if gameCode == GameCode.BB.rawValue {
            requestBBGames()
            return
        }
        if gameCode == GameCode.AG.rawValue {
            requestAGGames()
            return
        }
        if gameCode == GameCode.SB.rawValue {
            requestSBGames()
            return
        }
    }
}

// MARK - Game Types
extension PlayGamesViewController {
    func requestPTGames() {
        let request = GameRequestManager()
        request.getPlatformsPT(completionHandler: { (user, PTGame) in
            self.itemList = (PTGame?.games)!
            self.listItemView.reloadData()
        }) { (_error) in

        }
    }

    func requestTTGGames() {
        let request = GameRequestManager()
        request.getPlatformsTTG(completionHandler: { (user, TTGGames) in
            self.itemList = (TTGGames?.games)!
            self.listItemView.reloadData()
        }) { (_error) in
        }
    }

    func requestBBGames() {
        let request = GameRequestManager()
        request.getPlatformsBB(completionHandler: { (user, BBGames) in

        }) { (_error) in
        }
    }

    func requestAGGames() {
        let request = GameRequestManager()
        request.getPlatformsAG(completionHandler: { (user, BBGames) in

        }) { (_error) in
        }
    }

    func requestSBGames() {
        let request = GameRequestManager()
        request.getPlatformsSB(completionHandler: { (user, BBGames) in

        }) { (_error) in
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PlayGamesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == ListView.Menu.rawValue {
            return category.count
        }
        return itemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == ListView.Menu.rawValue {
            let menuCell = PlatformMenuCell.getCell(collectionView: collectionView, indexPath: indexPath)
            let row = indexPath.row
            menuCell.setMenu(title: category[row], index: row + 1)
            return menuCell
        }
        let listCell = PlatformCollectionCell.getCell(collectionView: collectionView, indexPath: indexPath)
        listCell.platform = platformType
        listCell.set(game: itemList[indexPath.row])
        return listCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableView: ListViewHeaderView? = nil
        if kind == UICollectionElementKindSectionHeader {
            reusableView = ListViewHeaderView.getHeaderView(collectionView: collectionView, indexPath: indexPath)
        }
        return reusableView!
    }
}

// MARK: - UICollectionViewDelegate
extension PlayGamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == ListView.Menu.rawValue {
            let menu = collectionView.cellForItem(at: indexPath) as? PlatformMenuCell
            let newItem = fixList.map({ (item) -> String in
                let current = item
                let index = menu?.index
                return "\(current).\(index!)"
            })
            print(newItem)
           // self.itemList = newItem
            self.listItemView.reloadData()
            return
        }

        let item = collectionView.cellForItem(at: indexPath) as? PlatformCollectionCell
        item?.launchGame()
        print(item?.lblTitle.text ?? "no")
    }
}
