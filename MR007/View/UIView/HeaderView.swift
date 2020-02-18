//
//  HeaderView.swift
//  MR007
//
//  Created by Roger Molas on 06/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

protocol HeaderViewDelegate: NSObjectProtocol {
    func didTap(header:HeaderView, at index:Int)
}

class HeaderView: UIView {
    weak var delegate: HeaderViewDelegate?
    fileprivate var section: Int = -1
    fileprivate var height:CGFloat = 0.0

    var isOpen:Bool = false

    convenience init(frame: CGRect, section: Int, target:Any?) {
        self.init(frame: frame)
        self.section = section
        self.height = CGFloat(frame.size.height)

        let button = UIButton(frame:self.frame)
        button.addTarget(self, action: #selector(HeaderView.toggle), for: .touchUpInside)
        self.addSubview(button)
    }

    convenience init(frame: CGRect, section: Int, target:Any?, title: String, color:UIColor?) {
        self.init(frame: frame)
        self.section = section
        self.backgroundColor = color
        self.height = CGFloat(frame.size.height)

        let button = UIButton(frame:self.frame)
        button.backgroundColor = color
        button.addTarget(self, action: #selector(HeaderView.toggle), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        self.addSubview(button)
    }

    convenience init(frame: CGRect, section: Int, target:Any?, image: UIImage) {
        self.init(frame: frame)
        self.section = section
        self.height = CGFloat(frame.size.height)

        let button = UIButton(frame:self.frame)
        button.addTarget(self, action: #selector(HeaderView.toggle), for: .touchUpInside)
        button.setImage(image, for: .normal)
        self.addSubview(button)
    }

    func toggle () {
        self.delegate?.didTap(header: self, at: self.section)
    }

    open func getHeight() -> CGFloat { return height }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
