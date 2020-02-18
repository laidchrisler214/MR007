//
//  HomeViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 22/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import ImageSlideshow
import SlideMenuControllerSwift
import Crashlytics

class HomeViewController: BaseViewController {
    @IBOutlet weak var recommendedGamesCollectionView: UICollectionView!
    @IBOutlet weak var topGamesCollectionView: UICollectionView!
    @IBOutlet weak var ttgGamesCollectionView: UICollectionView!
    @IBOutlet weak var newPtCollectionView: UICollectionView!
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var gameCenterButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var slideShow: ImageSlideshow!
    var bannerImages = [KingfisherSource]()
    var banners = [BannerModel]()
    var notifications = [NotificationsModel]()
    var selectedIndex = Int()
    let sharedUser = SharedUserInfo.sharedInstance
    var timer = Timer()
    var ctr = 0

    fileprivate var platforms:[LobbyGameModel]? = [LobbyGameModel]()
    fileprivate var topGames:[GameObjecModel]? = [GameObjecModel]()
    fileprivate var ttgGames:[GameObjecModel]? = [GameObjecModel]()
    fileprivate var newPtGames:[GameObjecModel]? = [GameObjecModel]()

    // Mark: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup sliding controller functions
        self.setNavigationBarItem()

        //Set slideshow config
        getBanners()

        //set Mail Badge
        checkUnreadMessages()

        getAnnouncements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        checkForActiveSegues()
        setActiveButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setRightNavigationItem()

        LoadingView.nativeProgress()
        let request = GameRequestManager()
        request.getHomePagePlatforms(completionHandler: { (user, platforms) in
            LoadingView.hide()
            self.platforms = platforms!
            self.sortPlatforms()
            self.recommendedGamesCollectionView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }

        request.getGames(completionHandler: { (user, list) in
            self.topGames = (list as? [GameObjecModel])!
            self.topGamesCollectionView.reloadData()
        }, error: { (error) in
        }, param: ["platform":"PT", "type":"12"])

        request.getGames(completionHandler: { (user, list) in
            self.ttgGames = (list as? [GameObjecModel])!
            self.ttgGamesCollectionView.reloadData()
        }, error: { (error) in
        }, param: ["platform":"TTG", "type":"12"])

        request.getGamesSW(completionHandler: { (user, list) in
            self.newPtGames = (list as? [GameObjecModel])!
            self.newPtCollectionView.reloadData()
        }, error: { (error) in
        }, param: ["platform":"SW", "type":"12"])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlatformGamesListViewController {
            destination.platformCode = platforms![selectedIndex].platformCode
        } else if let destination = segue.destination as? AllAnnounceMents {
            destination.announcements = self.notifications
        }
    }
    
    func checkForActiveSegues() {
        if let segueString = self.loadUserDefault(key: Segue.segueFromMenu) as? String {
            self.performSegue(withIdentifier: segueString, sender: nil)
        }
    }
    
    func setActiveButtons() {
        if !sharedUser.isLogIn() {
            depositButton.isEnabled = false
            withdrawButton.isEnabled = false
            gameCenterButton.isEnabled = false
        } else {
            depositButton.isEnabled = true
            withdrawButton.isEnabled = true
            gameCenterButton.isEnabled = true
        }
    }

    func sortPlatforms() {
        let temp = platforms![4]
        for i in stride(from:platforms!.count - 2, to: 1, by: -1 ) {
            platforms![i] = platforms![i-1]
        }
        platforms![1] = temp
    }

    func checkUnreadMessages() {
        let request = MessageRequestManager()
        request.requestMessages(completionHandler: { (user, messages, unreadCount) in
            if unreadCount! > 0 {
                if let tabItems = self.tabBarController?.tabBar.items as NSArray! {
                    let tabItem = tabItems[2] as? UITabBarItem
                    tabItem?.badgeValue = "\(unreadCount!)"
                }
            }
        }) { (error) in
        }
    }

    func getBanners() {
        let request = BannerRequestManager()
        request.getBanners(completionHandler: { (user, bannerModel) in
            self.banners = bannerModel
            self.setBanners()
        }) { (error) in
        }
    }

    func getAnnouncements() {
        let request = NotificationRequestManager()
        request.requestNotifications(completionHandler: { (user, notifications) in
            self.notifications = notifications!
            self.notificationButton.setTitle((notifications?[0].title)!, for: .normal)
            self.animateNotifications()
        }) { (error) in
        }
    }

    func animateNotifications() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateNotificationButton), userInfo: nil, repeats: true)
    }

    func updateNotificationButton() {
        ctr += 1
        if ctr == self.notifications.count {
            ctr = 0
        }
        self.notificationButton.slideInFromRight()
        self.notificationButton.setTitle(" \(self.notifications[ctr].title)", for: .normal)
    }

    func setBanners() {
        for banner in banners {
            let htmlString = banner.picUrl
            let encodedHtmlString = htmlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            self.bannerImages.append(KingfisherSource(urlString: encodedHtmlString!)!)
        }
        self.slideShow.slideshowInterval = 5
        self.slideShow.contentScaleMode = .scaleAspectFill
        self.slideShow.setImageInputs(self.bannerImages)
    }

    //MARK: - Button Actions
    @IBAction func segueToPromotionsAction(_ sender: Any) {
        performSegue(withIdentifier: "segueToPromotions", sender: nil)
    }

    @IBAction func popUpPlatforms(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func popUpNotifications(_ sender: Any) {
        performSegue(withIdentifier: "segueToNotifications", sender: self)
    }

    func launchPTGames(index: Int) {
        let user = SharedUserInfo.sharedInstance
        let urlBuilder = URLBuilder()
        Answers.logCustomEvent(withName: "Launch PT Game", customAttributes:
            ["user": user.getUserName(), "platform": "PT", "gameCode": topGames![index].gameCode ])
        let gameUrl = urlBuilder.baseURL + "pt/launch?gameCode=\(topGames![index].gameCode)&gameType=\(topGames![index].gameType)&sig=\(URLBuilder.getXAuthToken())"
        self.launchUrl(urlString: gameUrl)
    }

    func launchTTGGAmes(index: Int) {
        LoadingView.nativeProgress()
        let request = LaunchGameRequestManager()
        let param = ["gameCode": ttgGames![index].gameCode, "platform": "TTG"] as NSDictionary
        request.launchTTGSWGGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    func launchNewPTGAmes(index: Int) {
        LoadingView.nativeProgress()
        let request = LaunchGameRequestManager()
        let param = ["gameCode": newPtGames![index].gameCode, "platform": "SW"] as NSDictionary
        request.launchTTGSWGGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
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

    func launchAGGames(platform: String) {
        LoadingView.nativeProgress()
        let sharedUser = SharedUserInfo.sharedInstance
        let request = LaunchGameRequestManager()
        let param = ["platform": platform] as NSDictionary
        request.launchAGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Launch \(platform) Game", customAttributes: [ "user": sharedUser.getUserName() ])
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    func launchSBGames(platform: String) {
        LoadingView.nativeProgress()
        let sharedUser = SharedUserInfo.sharedInstance
        let request = LaunchGameRequestManager()
        let param = ["platform": platform] as NSDictionary
        request.launchSBGames(completionHandler: { (user, webUrl, mobileUrl) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Launch \(platform) Game", customAttributes: [ "user": sharedUser.getUserName() ])
            self.ggLaunchAlert(webUrl: webUrl!, mobileUrl: mobileUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    func ggLaunchAlert(webUrl: String, mobileUrl: String) {
        let alert = UIAlertController(title: alertMessage.displayModeSelect, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: alertMessage.mobileDisplayMode, style: .default, handler: { (action) in
            self.launchUrl(urlString: mobileUrl)
        }))
        alert.addAction(UIAlertAction(title: alertMessage.webDisplayMode, style: .default, handler: { (action) in
            self.launchUrl(urlString: webUrl)
        }))
        alert.addAction(UIAlertAction(title: alertMessage.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func launchGGGames(platform: String) {
        let sharedUser = SharedUserInfo.sharedInstance
        LoadingView.nativeProgress()
        let request = LaunchGameRequestManager()
        let param = ["platform": platform] as NSDictionary
        request.launchTTGSWGGGames(completionHandler: { (user, gameUrl) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Launch \(platform) Game", customAttributes: ["user": sharedUser.getUserName()])
            self.launchUrl(urlString: gameUrl!)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.tabBarController?.setTabBarVisible(visible: false, duration: 0.3, animated: true)
        }
        else {
            self.tabBarController?.setTabBarVisible(visible: true, duration: 0.3, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recommendedGamesCollectionView {
            return (self.platforms?.count)!
        } else if collectionView == self.topGamesCollectionView {
            return (self.topGames?.count)!
        } else if collectionView == self.ttgGamesCollectionView {
            return (self.ttgGames?.count)!
        } else if collectionView == self.newPtCollectionView {
            return (self.newPtGames?.count)!
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recommendedGamesCollectionView {
            let cell:RecommendedCell = (collectionView.dequeueReusableCell(
                withReuseIdentifier: "RecommendedCell", for: indexPath) as? RecommendedCell)!
            cell.setCell(newGame: self.platforms![indexPath.row], index: indexPath.row)
            return cell
        } else if collectionView == self.topGamesCollectionView {
            let cell:TopGamesCell = (collectionView.dequeueReusableCell(
                withReuseIdentifier: "TopGamesCell", for: indexPath) as? TopGamesCell)!
            cell.setCell(topGame: self.topGames![indexPath.row])
            return cell
        } else if collectionView == self.ttgGamesCollectionView {
            let cell:TTGCell = (collectionView.dequeueReusableCell(
                withReuseIdentifier: "TTGCell", for: indexPath) as? TTGCell)!
            cell.setCell(topGame: self.ttgGames![indexPath.row])
            return cell
        } else if collectionView == self.newPtCollectionView {
            let cell:NewPTCell = (collectionView.dequeueReusableCell(
                withReuseIdentifier: "NewPTCell", for: indexPath) as? NewPTCell)!
            cell.setCell(topGame: self.newPtGames![indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.recommendedGamesCollectionView {
            return CGSize(width: collectionView.frame.size.width * 0.49, height: collectionView.frame.size.height * 0.30)
        }
        return CGSize(width: collectionView.frame.size.width * 0.25, height: collectionView.frame.size.height * 0.90)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sharedUser.isLogIn() {
            if collectionView == self.recommendedGamesCollectionView {
                let platform = platforms![indexPath.row].platformCode
                if platform == "PT" || platform == "TTG" || platform == "SW" {
                    selectedIndex = indexPath.row
                    self.performSegue(withIdentifier: "SegueToGames", sender: self)
                } else if platform == "AG"{
                    self.launchAGGames(platform: platform)
                } else if platform == "SB" {
                    self.launchSBGames(platform: platform)
                } else {
                    self.launchGGGames(platform: platform)
                }
            } else if collectionView == self.topGamesCollectionView {
                self.launchPTGames(index: indexPath.row)
            } else if collectionView == self.ttgGamesCollectionView {
                self.launchTTGGAmes(index: indexPath.row)
            } else if collectionView == self.newPtCollectionView {
                self.launchNewPTGAmes(index: indexPath.row)
            }
        } else {
            self.toggleLogIn()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {

}
