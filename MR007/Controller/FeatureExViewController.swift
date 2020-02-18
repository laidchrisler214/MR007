//
//  FeatureExViewController.swift
//  MR007
//
//  Created by GreatFeat on 20/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

class FeatureExViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var platforms = [LobbyGameModel]()
    var selectedIndex = Int()
    let sharedUser = SharedUserInfo.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        getPlatforms()
    }

    //MARK: API
    func getPlatforms() {
        let request = GameRequestManager()
        request.getHomePagePlatforms(completionHandler: { (user, platforms) in
            self.platforms = platforms!
            self.collectionView.reloadData()
            self.slideDown()
        }) { (error) in
            self.slideUp()
        }
    }

    func launchAGSBGames(platform: String) {
//        LoadingView.nativeProgress()
//        let sharedUser = SharedUserInfo.sharedInstance
//        let request = LaunchGameRequestManager()
//        let param = ["platform": platform] as NSDictionary
//        request.launchAGSBGames(completionHandler: { (user, gameUrl) in
//            LoadingView.hide()
//            Answers.logCustomEvent(withName: "Launch \(platform) Game", customAttributes: [ "user": sharedUser.getUserName() ])
//            self.launchUrl(urlString: gameUrl!)
//        }, error: { (error) in
//            LoadingView.hide()
//        }, param: param)
    }

    func launchGGGames(platform: String) {
        LoadingView.nativeProgress()
        let sharedUser = SharedUserInfo.sharedInstance
        let request = LaunchGameRequestManager()
        let param = ["platform": platform] as NSDictionary
        request.launchTTGSWGGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Launch \(platform) Game", customAttributes: [ "user": sharedUser.getUserName() ])
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlatformGamesListViewController {
            destination.platformCode = platforms[selectedIndex].platformCode
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

    @IBAction func dismissView(_ sender: Any) {
        self.slideUp()
    }

}

extension FeatureExViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:VendorCells = (collectionView.dequeueReusableCell(withReuseIdentifier: "VendorCells", for: indexPath) as? VendorCells)!
        cell.set(data: self.platforms[indexPath.row])
        return cell
    }
}

extension FeatureExViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sharedUser.isLogIn() {
            let platform = platforms[indexPath.row].platformCode
            if platform == "PT" || platform == "TTG" || platform == "SW" {
                selectedIndex = indexPath.row
                self.performSegue(withIdentifier: "SegueToGames", sender: self)
            } else if platform == "AG" || platform == "SB"{
                self.launchAGSBGames(platform: platform)
            } else {
                self.launchGGGames(platform: platform)
            }
        }
    }
}

extension FeatureExViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.009, height: collectionView.frame.size.height / 3.01)
    }
}
