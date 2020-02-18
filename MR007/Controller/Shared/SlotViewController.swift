//
//  SlotViewController.swift
//  MR007
//
//  Created by Roger Molas on 02/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// Table Sections
fileprivate enum TableSection:Int {
    case MainWallet = 0
    case Options    = 1
    case Button     = 2
    case Count      = 3
}

class SlotViewController: BaseViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerImage:UIImageView!
    fileprivate var games:[AnyObject]? = [AnyObject]()

    var gameCode: String = ""
    var headerURL: URL? = nil

    var currentGame: BaseGameModel? = nil
    var currentWallet = WalletModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Parse header image
        self.headerImage.kf.setImage(with:headerURL)
        getGameInfo()
    }

    @IBAction func startPlayFlatform () {
        if gameCode == GameCode.PT.rawValue {
            self.performSegue(withIdentifier: Segue.showPlayGames, sender: self)
            return
        }
        if gameCode == GameCode.TTG.rawValue {
            self.performSegue(withIdentifier: Segue.showPlayGames, sender: self)
            return
        }
        if gameCode == GameCode.BB.rawValue {
            self.performSegue(withIdentifier: Segue.showPlayGames, sender: self)
            return
        }
        if gameCode == GameCode.AG.rawValue {
            self.performSegue(withIdentifier: Segue.showPlayWebGame, sender: self)
            return
        }
        if gameCode == GameCode.SB.rawValue {
            self.performSegue(withIdentifier: Segue.showPlayWebGame, sender: self)
            return
        }
    }

    //MARK : - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Navigate to Play Tech Game
        if let destination = segue.destination as? PlayGamesViewController {
            if gameCode == GameCode.PT.rawValue {
                destination.itemList = (self.games as? [PTGame])!
                destination.platformType = "pt"
                return
            }

            if gameCode == GameCode.TTG.rawValue {
                destination.itemList = (self.games as? [TTGameModel])!
                destination.platformType = "ttg"
                return
            }
        }

        // Game that required login
        if let destination = segue.destination as? WebViewController {
            destination.urlString = (currentGame?.gameLink)!
            destination.titleString = self.gameCode
        }
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

// MARK: - Game Types
extension SlotViewController {
    func requestPTGames() {
        let request = GameRequestManager()
        request.getPlatformsPT(completionHandler: { (user, PTGame) in
            self.games = PTGame?.games
        }) { (_error) in
        }
    }

    func requestTTGGames() {
        let request = GameRequestManager()
        request.getPlatformsTTG(completionHandler: { (user, TTGGames) in
            self.games = TTGGames?.games
        }) { (_error) in
        }
    }

    func requestBBGames() {
        let request = GameRequestManager()
        request.getPlatformsBB(completionHandler: { (user, bbgame) in

        }) { (_error) in
        }
    }

    func requestAGGames() {
        let request = GameRequestManager()
        request.getPlatformsAG(completionHandler: { (user, agGame) in
            self.currentGame = agGame
        }) { (_error) in
        }
    }

    func requestSBGames() {
        let request = GameRequestManager()
        request.getPlatformsSB(completionHandler: { (user, sbGame) in
            self.currentGame = sbGame
        }) { (_error) in
        }
    }
}

// MARK: - Platform Transactions (Transfer In/Out, Get rebate)
extension SlotViewController {
    func transferIn() {
        let transferAlert = AlertViewTransferIn(title: alertMessage.turnInto, message: "", preferredStyle: .alert)
        transferAlert.gameCode = self.gameCode
        transferAlert.setUpView()
        transferAlert.delegate = self
        self.present(transferAlert, animated: true, completion: nil)
    }

    func transferOut() {
        let transferAlert = AlertViewTransferOut(title: alertMessage.turnOut, message: "", preferredStyle: .alert)
        transferAlert.gameCode = self.gameCode
        transferAlert.setUpView()
        transferAlert.delegate = self
        self.present(transferAlert, animated: true, completion: nil)
    }

    func getRebate() {
        LoadingView.nativeProgress()
        let request = RebateRequestManager()
        request.requestRebate(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.success, message: response)
            self.updateView()
        }, error: { (error) in

        }, params: ["platform":gameCode])
    }

    /// Send Transfer In Request
    func sendTransferInRequest(param: NSDictionary) {
        LoadingView.nativeProgress()
        let request = TransferRequestManager()
        request.requestTransferIn(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.success, message: response)
            self.updateView()

        }, error: { (error) in

        }, params: param)
    }

    /// Send Transfer Out Request
    func sendTransferOutRequest(param: NSDictionary) {
        LoadingView.nativeProgress()
        let request = TransferRequestManager()
        request.requestTransferOut(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.success, message: response)
            self.updateView()

        }, error: { (error) in

        }, params: param)
    }

    /// Update view after transactions
    func updateView() {
        let indexPath = IndexPath(row: 0, section: TableSection.MainWallet.rawValue)
        let wallet = self.tableView.cellForRow(at: indexPath) as? WalletCell
        wallet?.requestBalance()
    }
}

// MARK: - AlertViewTransferInDelegate
extension SlotViewController: AlertViewTransferInDelegate {
    func didTransferInRequest(param: NSDictionary?) {
        self.sendTransferInRequest(param: param!)
    }
}

// MARK: - AlertViewTransferInDelegate
extension SlotViewController: AlertViewTransferOutDelegate {
    func didTransferOutRequest(param: NSDictionary?) {
        self.sendTransferOutRequest(param: param!)
    }
}

// MARK: - UITableViewDataSource
extension SlotViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.Count.rawValue
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == TableSection.MainWallet.rawValue {
            return tableView.getHeaderHeight()
        }
        if section == TableSection.Options.rawValue {
            return tableView.getHeaderHeight()
        }
        return 0.1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TableSection.MainWallet.rawValue {
            return Account.PlatformInfo
        }
        if section == TableSection.Options.rawValue {
            return Account.PlatformOptions
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.Options.rawValue {
            return 3
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        switch indexPath.section {  /// Options Cell (Transfer In/Out, Get Rebate)
        case TableSection.Options.rawValue:
            let transactionCell = PlatformTransCell.getCell(tableView: tableView)
            transactionCell.setOption(tag: row)
            return transactionCell

        case TableSection.Button.rawValue:  /// Start button
            let buttonCell = SingleButtonCell.getCell(tableView: tableView)
            buttonCell.isUserInteractionEnabled = true
            return buttonCell

        default:  /// Main Wallet
            let walletCell = WalletCell.getCell(tableView: tableView)
            walletCell.gameCode = self.gameCode
            walletCell.requesting()
            return walletCell
        }
    }
}

// MARK: - UITableViewDelegate
extension SlotViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// Transaction section
        if indexPath.section == TableSection.Options.rawValue {
            let cell = tableView.cellForRow(at: indexPath) as? PlatformTransCell
            if cell?.type == PlatformTransaction.TransferIn.rawValue {
                self.transferIn()
            }

            if cell?.type == PlatformTransaction.TransferOut.rawValue {
                self.transferOut()
            }

            if cell?.type == PlatformTransaction.Rebate.rawValue {
                self.getRebate()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TableSection.MainWallet.rawValue {
            return WalletCell.height
        }
        if indexPath.section == TableSection.Button.rawValue {
            return UITableViewCell.buttonCellHeight
        }
        return UITableViewCell.defaultCellHeight // Default height
    }
}
