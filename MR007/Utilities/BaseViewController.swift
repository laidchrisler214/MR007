//
//  BaseViewController.swift
//  MR007
//
//  Created by GreatFeat on 12/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let hexColor = HexColorConverter()
    let alertMessage = AlertMessage()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func saveUserDefault(item:Any ,key:String){
        UserDefaults.standard.set(item, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func loadUserDefault(key:String)->Any?{
        return UserDefaults.standard.object(forKey: key)
    }

    func removeUserDefault(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func goBackOneView() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }

    func slideDown() {
        self.view.frame.origin.y = -500.0
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.frame.origin.y = 0
        })
    }

    func slideUp() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame.origin.y = -500.0
            self.view.alpha = 0.0
        }, completion: { (finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}
