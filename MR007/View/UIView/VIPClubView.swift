//
//  VIPClubView.swift
//  MR007
//
//  Created by GreatFeat on 09/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class VIPClubView: UIView {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    var vipPhotos = [#imageLiteral(resourceName: "vip0"), #imageLiteral(resourceName: "vip1"), #imageLiteral(resourceName: "vip2"), #imageLiteral(resourceName: "vip3"), #imageLiteral(resourceName: "vip4"), #imageLiteral(resourceName: "vip5"), #imageLiteral(resourceName: "vip6"), #imageLiteral(resourceName: "vip7"), #imageLiteral(resourceName: "vip8"), #imageLiteral(resourceName: "vip9"), #imageLiteral(resourceName: "vip10"), #imageLiteral(resourceName: "vip11"), #imageLiteral(resourceName: "vip12"), #imageLiteral(resourceName: "vip13")]

    class func loadView() -> VIPClubView {
        let nib = UINib(nibName: "VIPClubView", bundle: Bundle.main)
        let views = nib.instantiate(withOwner: self, options: nil)
        let view = views[0] as? VIPClubView
        return view!
    }

    class func loadLevelView() -> VIPClubView {
        let nib = UINib(nibName: "VIPClubView", bundle: Bundle.main)
        let views = nib.instantiate(withOwner: self, options: nil)
        let view = views[1] as? VIPClubView
        return view!
    }

    func setUpView(level: Int) {
        self.thumbnail.image = vipPhotos[level]
    }

    func setLevel(level: Int) {
        self.detailLabel.text = "Lv.\(level)"
    }

    func setUserLevel(level: Int) {
        self.detailLabel.text = "尚未晋级：Lv.\(level)"
    }

    func setVIP(model: VIPBonusModel) {

    }
}
