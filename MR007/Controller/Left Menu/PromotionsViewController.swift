//
//  PromotionsViewController.swift
//  MR007
//
//  Created by Roger Molas on 06/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class PromotionsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var banners = [BannerPromoModel]()
    var promotionDetails = [PromotionDetails]()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBarItem()
        getBanners()
        //getBannerDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.removeUserDefault(key: Segue.segueFromMenu)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getBanners() {
        let request = BannerRequestManager()
        LoadingView.nativeProgress()
        request.getBannerPromo(completionHandler: { (user, bannerModel) in
            LoadingView.hide()
            self.banners = bannerModel
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }
    
//    func getBannerDetails() {
//        let request = BasicAuthRequestManager()
//        request.getPromotionDetailsRequest(completionHandler: { (promos) in
//            self.promotionDetails = promos
//        }) { (error) in
//            Alert.with(title: "Error", message: error.localizedDescription)
//        }
//    }

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

    @IBAction func segmentValueDidChange(_ sender: UISegmentedControl) {
        print("Selected \(sender.selectedSegmentIndex)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PromoDetailsViewController {
            destination.bannerImage = banners[selectedIndex].bannerUrl
            destination.bannerDetails = banners[selectedIndex].content
        }
    }
}

// MARK: UITableViewDataSource
extension PromotionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Promotion Cell", for: indexPath) as? PromotionCell
        cell?.setDetails(bannerModel: banners[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}

// MARK: UITableViewDelegate
extension PromotionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: Segue.promotions, sender: nil)

//        for i in 0..<promotionDetails.count {
//            if banners[indexPath.row].bannerUrl == promotionDetails[i].link {
//                tableView.deselectRow(at: indexPath, animated: true)
//                self.performSegue(withIdentifier: Segue.promotions, sender: nil)
//                self.selectedIndex = i
//            }
//        }

        //launchUrl(urlString: banners[indexPath.row].buttonLink)
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.performSegue(withIdentifier: Segue.promotions, sender: nil)
    }
}
