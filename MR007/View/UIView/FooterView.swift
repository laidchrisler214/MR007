//
//  FooterView.swift
//  MR007
//
//  Created by Roger Molas on 06/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate let color = UIColor(red: 25.0 / 255, green: 69.0 / 255, blue: 95.0 / 255, alpha: 1.0)
fileprivate let bottomMargin: CGFloat = 7.0
fileprivate let size = CGSize(width: 15, height: 15)

class FooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = color

        let image = UIImage(named: "arrow-down")
        let arrow = UIImageView(image: image)
        arrow.contentMode = .scaleAspectFit

        let posX = self.bounds.size.width / 2
        let posY = self.bounds.size.height / 2
        arrow.frame = CGRect(x: posX - size.width / 2,
                             y: (posY - size.height / 2) - bottomMargin,
                             width: size.width,
                             height: size.height)
        self.addSubview(arrow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
