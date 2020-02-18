//
//  UserInfoViewController.swift
//  MR007
//
//  Created by GreatFeat on 28/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    //MARK: PROPERTIES
    let user = SharedUserInfo.sharedInstance
    var vipPhotos = [#imageLiteral(resourceName: "vip0"), #imageLiteral(resourceName: "vip1"), #imageLiteral(resourceName: "vip2"), #imageLiteral(resourceName: "vip3"), #imageLiteral(resourceName: "vip4"), #imageLiteral(resourceName: "vip5"), #imageLiteral(resourceName: "vip6"), #imageLiteral(resourceName: "vip7"), #imageLiteral(resourceName: "vip8"), #imageLiteral(resourceName: "vip9"), #imageLiteral(resourceName: "vip10"), #imageLiteral(resourceName: "vip11"), #imageLiteral(resourceName: "vip12"), #imageLiteral(resourceName: "vip13")]
    var userLevel = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBarItem()
        setLayout()
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

    //MARK: HELPER
    func setLayout() {
        let userDetails = user.getUserDetails()
        userNameLabel.text = user.getUserName()
        userLevel = userDetails["user_level"] as? Int ?? 0
        levelLabel.text = String(userLevel)
        getBalance()
        realNameLabel.text = userDetails["full_name"] as? String ?? ""
        birthdayLabel.text = userDetails["birthday"] as? String ?? ""
        getNumber()
        getEmail()
        setAvatar()
    }

    func setAvatar() {
        self.userAvatar.image = vipPhotos[userLevel]
    }

    func getBalance() {
        let stringBalance = user.getUserMainBalance()
        var balance = Double(stringBalance)
        balance = round(1000 * balance!) / 1000
        let balanceString = String(format: "%.2f", balance!)
        balanceLabel.text = balanceString
    }

    func getNumber() {
        let userDetails = user.getUserDetails()
        let number = userDetails["mobile"] as? String ?? ""
        let limit = number.count - 4
        var filler = ""
        for _ in 0..<limit {
            filler = filler + "*"
        }
        numberLabel.text = filler + number.suffix(4)
    }

    func getEmail() {
        let userDetails = user.getUserDetails()
        let email = userDetails["email"] as? String ?? ""
        print(email)
        let range = email.range(of: "@")
        var limit = email.distance(from: email.startIndex, to: (range?.lowerBound)!)
        limit = limit - 4
        let suffixValue = email.count - limit
        var filler = ""
        for _ in 0..<limit {
            filler = filler + "*"
        }
        emailLabel.text = filler + email.suffix(suffixValue)
    }
    
    //MARK: - Button Actions
    @IBAction func goToChangePassword(_ sender: Any) {
        performSegue(withIdentifier: "segueToChangePass", sender: nil)
    }
    
}
