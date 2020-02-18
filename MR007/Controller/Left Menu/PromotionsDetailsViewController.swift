//
//  PromotionsDetailsViewController.swift
//  MR007
//
//  Created by GreatFeat on 15/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class PromotionsDetailsViewController: UITableViewController {

    @IBOutlet weak var bannerImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bannerImage.image = #imageLiteral(resourceName: "img_promotion")
        self.navigationItem.title = "活动详情"
    }
}
