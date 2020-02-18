//
//  PlatformGamesListViewController.swift
//  MR007
//
//  Created by GreatFeat on 24/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

class PlatformGamesListViewController: BaseViewController {

    // MARK: - OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainer: UIView!

    // MARK: - PROPERTIES
    var searchController: UISearchController!
    var gameCategory = String()
    var platformCode = String()
    var gamelist = [GameObjecModel]()
    var filteredGames = [GameObjecModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameCategory = "8"
        tableView.register(UINib(nibName: "PlatformGameCell", bundle: nil), forCellReuseIdentifier: "PlatformGameCell")
        configureSearchController()
        getGames()
    }

    // MARK: - API
    func getGames() {
        let request = GameRequestManager()
        let param = self.setParam()
        self.gamelist.removeAll()
        self.filteredGames.removeAll()
        LoadingView.nativeProgress()
        if self.platformCode == "SW" {
            request.getGamesSW(completionHandler: { (user, list) in
                LoadingView.hide()
                self.gamelist = (list as? [GameObjecModel])!
                self.filteredGames = self.gamelist
                self.tableView.reloadData()
            }, error: { (error) in
                LoadingView.hide()
            }, param: param)
        } else {
            request.getGames(completionHandler: { (user, list) in
                LoadingView.hide()
                self.gamelist = (list as? [GameObjecModel])!
                self.filteredGames = self.gamelist
                self.tableView.reloadData()
            }, error: { (error) in
                LoadingView.hide()
            }, param: param)
        }
    }

    // MARK: - GAME LAUNCH
    func launchPTGames(sender: UIButton) -> Void {
        let user = SharedUserInfo.sharedInstance
        let urlBuilder = URLBuilder()
        Answers.logCustomEvent(withName: "Launch \(self.platformCode) Game", customAttributes: ["user": user.getUserName(), "platform":self.platformCode, "gameCode": gamelist[sender.tag].gameCode])
        let gameUrl = urlBuilder.baseURL + "pt/launch?gameCode=\(gamelist[sender.tag].gameCode)&gameType=\(gamelist[sender.tag].gameType)&sig=\(URLBuilder.getXAuthToken())"
        print(gameUrl)
        self.launchUrl(urlString: gameUrl)
    }

    func launchSWTTGGAmes(sender: UIButton) -> Void {
        LoadingView.nativeProgress()
        let user = SharedUserInfo.sharedInstance
        Answers.logCustomEvent(withName: "Launch \(self.platformCode) Game", customAttributes: ["user": user.getUserName(), "platform":self.platformCode, "gameCode": gamelist[sender.tag].gameCode])
        let request = LaunchGameRequestManager()
        let param = ["gameCode": gamelist[sender.tag].gameCode, "platform": self.platformCode] as NSDictionary
        request.launchTTGSWGGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    //MARK: - HELPER
    func setParam() -> NSDictionary {
        if self.platformCode == "SW" {
            return ["platform":self.platformCode]
        } else {
            return ["platform":self.platformCode, "type":self.gameCategory]
        }
    }

    func launchUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "搜索游戏名称"
        searchController.searchBar.sizeToFit()
        self.searchContainer.addSubview(searchController.searchBar)
    }
}

// MARK: - Tableview Datasource and Delegate
extension PlatformGamesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredGames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PlatformGameCell = (tableView.dequeueReusableCell(withIdentifier: "PlatformGameCell", for: indexPath) as? PlatformGameCell)!
        cell.setCell(platformCode: self.platformCode, model: self.filteredGames[indexPath.row])
        cell.playButton.tag = indexPath.row
        if self.platformCode == "PT" {
            cell.playButton.addTarget(self, action: #selector(launchPTGames), for: UIControlEvents.touchUpInside)
        } else {
            cell.playButton.addTarget(self, action: #selector(launchSWTTGGAmes), for: UIControlEvents.touchUpInside)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension PlatformGamesListViewController: UITableViewDelegate {
}

// MARK: - SEARCH CONTROL
extension PlatformGamesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //display another table here to show search results
        if searchController.searchBar.text! == "" {
            filteredGames = gamelist
        } else {
            // Filter the results
            filteredGames = gamelist.filter { $0.englishName.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }

        self.tableView.reloadData()
    }
}

