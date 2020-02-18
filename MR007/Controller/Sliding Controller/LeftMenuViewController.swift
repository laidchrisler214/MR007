//
//  LeftMenuViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

enum LeftMenuType: Int {
    case vip = 0
    case promotion = 1
    case cooperation = 2
    case about = 3
}

class LeftMenuViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var logOutImageView: UILabel!
    @IBOutlet weak var logOutLabel: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var settingsIconButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var promoButton: UIButton!
    @IBOutlet weak var coopButton: UIButton!
    @IBOutlet weak var promoCount: UIButton!
    
    let viewControllerManager:ViewControllerManager = ViewControllerManager.sharedInstance
    var vipPhotos = [#imageLiteral(resourceName: "vip0"), #imageLiteral(resourceName: "vip1"), #imageLiteral(resourceName: "vip2"), #imageLiteral(resourceName: "vip3"), #imageLiteral(resourceName: "vip4"), #imageLiteral(resourceName: "vip5"), #imageLiteral(resourceName: "vip6"), #imageLiteral(resourceName: "vip7"), #imageLiteral(resourceName: "vip8"), #imageLiteral(resourceName: "vip9"), #imageLiteral(resourceName: "vip10"), #imageLiteral(resourceName: "vip11"), #imageLiteral(resourceName: "vip12"), #imageLiteral(resourceName: "vip13")]
    var userLevel = Int()
    let hex = HexColorConverter()
    var banners = [BannerModel]()

    // MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTargets()
        getBanners()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = SharedUserInfo.sharedInstance
        if user.isLogIn() {
            let user = SharedUserInfo.sharedInstance
            userNameLabel.text = user.getUserName()
            let stringBalance = user.getUserMainBalance()
            var balance = Double(stringBalance)
            balance = round(1000 * balance!) / 1000
            let balanceString = String(format: "%.2f", balance!)
            balanceLabel.text = "主账户余额 ¥\(balanceString)"
             userNameLabel.isHidden = false
            logOutImageView.isHidden = false
            logOutLabel.isHidden = false
            logOutButton.isEnabled = true
            levelButton.isEnabled = true
            let userDetails = user.getUserDetails()
            userLevel = userDetails["user_level"] as? Int ?? 0
            levelLabel.text = "VIP等级\(userLevel)"
        } else {
            levelButton.isEnabled = false
            userNameLabel.isHidden = true
            balanceLabel.text = "请先进行注册/登录"
            logOutImageView.isHidden = true
            logOutLabel.isHidden = true
            logOutButton.isEnabled = false
        }

        // set image
        self.avatarImageView.image = vipPhotos[userLevel]

        //settings button circular border
        settingsIconButton.layer.cornerRadius = settingsIconButton.frame.size.width / 2
    }
    
    //MARK: - API
    func getBanners() {
        let request = BannerRequestManager()
        request.getBanners(completionHandler: { (user, bannerModel) in
            self.banners = bannerModel
            self.promoCount.isHidden = false
            self.promoCount.setTitle(String(bannerModel.count), for: .normal)
        }) { (error) in
        }
    }
    
    //MARK: - HELPER
    func setButtonTargets() {
        levelButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        promoButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        coopButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        levelButton.addTarget(self, action: #selector(handleUntouch), for: .touchDown)
        promoButton.addTarget(self, action: #selector(handleUntouch), for: .touchDown)
        coopButton.addTarget(self, action: #selector(handleUntouch), for: .touchDown)
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func showSettings() {
        let user = SharedUserInfo.sharedInstance
        if user.isLogIn() {
            viewControllerManager.showUserInfo()
        }
    }

    @IBAction func logoutAction() {
        let alert = Alert.logOutAlert()
        let action = Alert().logOut { (action) in
            let logInRequest = LoginRequestManager()
            logInRequest.sendLogoutRequest(completionHandler: { (response) in
                self.viewControllerManager.showHome()
            }, error: nil)
        }
        alert.addAction(action)
        alert.addAction(Alert().cancelButton(action: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func showVipAction(_ sender: Any) {
        viewControllerManager.showVipClub()
    }

    @IBAction func showPromoAction(_ sender: Any) {
        viewControllerManager.showPromotions()
    }

    @IBAction func showCoopAction(_ sender: Any) {
        viewControllerManager.showCooperation()
    }

    func handleTouch(sender: UIButton) -> Void {
        sender.backgroundColor = hex.UIColorFromHex(hexValue: 0x05354B, alpha: 0.0)
    }
    
    func handleUntouch(sender: UIButton) -> Void {
        sender.backgroundColor = hex.UIColorFromHex(hexValue: 0x05354B, alpha: 0.50)
    }
}

