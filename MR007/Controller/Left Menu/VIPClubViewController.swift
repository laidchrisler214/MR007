//
//  VIPClubViewController.swift
//  MR007
//
//  Created by GreatFeat on 09/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import iCarousel
import Foundation
import UIKit

class VIPClubViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var numberOfDesposit: UILabel!
    @IBOutlet weak var totalAmountDesposit: UILabel!
    @IBOutlet weak var bonusDetails: UILabel!

    var items: [Int] = []
    var bonuses = [VIPBonusModel]()
    var selectedIndex = Int()
    var currentLevel = Int()
    var user = UserModel()
    var initialLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBarItem()
        self.carousel.type = .linear

        self.selectedIndex = 0
        self.currentLevel = 0
        self.initialRequestVIPBonus(level: "\(currentLevel)")
        self.carousel.scrollToItem(at: currentLevel, animated: false)
        //self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.removeUserDefault(key: Segue.segueFromMenu)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.carousel.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }

    /// Get VIP Bonus
    func requestVIPBonus(level: String) {
        let request = BonusRequestManager()
        request.getVIPBonus(completionHandler: { (user, bonusList) in
            self.bonuses = (bonusList as? [VIPBonusModel])!
            self.user = user!
            self.setUserData()
            LoadingView.hide()
        }, error: { (error) in

        }, params:["level":level],
           isLoggedIn: SharedUserInfo.sharedInstance.isLogIn())
    }

    func initialRequestVIPBonus(level: String) {
        let request = BonusRequestManager()
        LoadingView.nativeProgress()
        request.getVIPBonus(completionHandler: { (user, bonusList) in
            self.bonuses = (bonusList as? [VIPBonusModel])!
            self.user = user!
            self.setUserData()
            self.requestVIPBonus(level: "\(self.currentLevel)")
        }, error: { (error) in

        }, params:["level":level],
           isLoggedIn: SharedUserInfo.sharedInstance.isLogIn())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0..<13 {
            items.append(i)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VIPBonusViewController {
            let cell = sender as? VIPClubCell
            destination.currentBonus = cell?.currentBonus
        }
    }

    func setUserData() {
        numberOfDesposit.text = "\(self.user.level)"
        var balance = Double(self.user.balance)
        balance = round(1000 * balance!) / 1000
        totalAmountDesposit.text = String(format: "%.2f", balance!)
        currentLevel = self.user.level
        if initialLoad {
            selectedIndex = currentLevel
        }
        self.carousel.scrollToItem(at: selectedIndex, animated: true)
        self.tableView.reloadData()
        self.carousel.reloadData()
        self.collectionView.reloadData()
    }
}

extension VIPClubViewController: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count + 1
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if index == selectedIndex {
            let itemView = VIPClubView.loadLevelView()
            itemView.setUpView(level: index)
            itemView.setUserLevel(level: index)
            return itemView
        }

        let itemView = VIPClubView.loadView()
        itemView.setUpView(level: index)
        //itemView.setLevel(level: index)
        return itemView
    }

    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        return value
    }
}

extension VIPClubViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        LoadingView.nativeProgress()
        self.requestVIPBonus(level: "\(items[index])")
        self.selectedIndex = index
        self.initialLoad = false
        self.carousel.reloadData()
    }
}

/// TableView
extension VIPClubViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bonuses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIP Club Cell", for: indexPath) as? VIPClubCell
        cell?.setVIP(bonus: bonuses[indexPath.row])
        return cell!
    }
}

extension VIPClubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? VIPClubCell
        self.performSegue(withIdentifier: Segue.vipBonus, sender: cell)
    }
}

extension VIPClubViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:VIPlevelBarCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "VIPlevelBarCell", for: indexPath) as? VIPlevelBarCell)!
        cell.setCell(index: indexPath.row, currentLevel: currentLevel)
        return cell
    }
}

extension VIPClubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 14.5, height: collectionView.frame.size.height)
    }
}
