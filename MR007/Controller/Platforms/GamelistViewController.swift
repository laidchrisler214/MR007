//
//  GamelistViewController.swift
//  MR007
//
//  Created by GreatFeat on 08/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

internal enum Type: String {
    case feature
    case all
    case hot
    case top
}

fileprivate struct CategoryType {
    mutating func filter(type: Type, plaform: String) -> String {
        if plaform == "PT" {
            return getPTCategory(type: type)
        }
        return getTTGCategory(type: type)
    }

    func getPTCategory(type: Type) -> String {
        var mType = ""
        switch type {
            case .feature:
                mType = "11"
            case .all:
                mType = "8"
            case .hot:
                mType = "20"
            case .top:
                mType = "12"
        }
        return mType
    }

    func getTTGCategory(type:Type) -> String {
        var mType = ""
        switch type {
        case .feature:
            mType = "3"
        case .all:
            mType = "0"
        case .hot:
            mType = "2"
        case .top:
            mType = "1"
        }
        return mType
    }
}

class GamelistViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!

    let searchController = UISearchController(searchResultsController: nil)

    var gamelist = [GameObjecModel]()
    var gameCode = ""
    var gameType = ""

    fileprivate var categoryType = CategoryType()

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (self.navigationController?.navigationBar.frame.size.width)! - 20
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        title.text = "\(gameCode) Category"
        title.textAlignment = .center
        title.backgroundColor = UIColor.clear

        self.navigationItem.titleView = title
        self.tableview.tableFooterView = UIView()
        requestGames(type: categoryType.filter(type: .feature, plaform: gameCode))
    }

    func requestGames(type: String) {
        let request = GameRequestManager()
        request.getGames(completionHandler: { (user, list) in
            if (list?.count)! > 0 {
                self.gamelist = (list as? [GameObjecModel])!
                self.tableview.reloadData()
            }

        }, error: { (error) in

        }, param: NSDictionary(dictionaryLiteral: ("platform", gameCode), ("type", type)))
    }
}

extension GamelistViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamelist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameCell.getCell(tableView: tableView, indexPath: indexPath)
        cell.platform = gameCode
        cell.set(game: gamelist[indexPath.row])
        return cell
    }
}

extension GamelistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GamelistViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
           requestGames(type: categoryType.filter(type: .feature, plaform: gameCode))
        }

        if selectedScope == 1 {
            requestGames(type: categoryType.filter(type: .all, plaform: gameCode))
        }

        if selectedScope == 2 {
            requestGames(type: categoryType.filter(type: .hot, plaform: gameCode))
        }

        if selectedScope == 3 {
           requestGames(type: categoryType.filter(type: .top, plaform: gameCode))
        }
    }
}
