//
//  LoadingView.swift
//  MR007
//
//  Created by Roger Molas on 17/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import PKHUD

fileprivate enum Title: String {
    case login = "证实"
}

class LoadingView: NSObject {

    override init() {
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
    }

    class func hide() {
        HUD.hide()
    }

    class func logInProgress() {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: Title.login.rawValue, subtitle: nil))
        }
    }

    class func nativeProgress() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }

    class func success(completion: @escaping (Void) -> Void) {
        DispatchQueue.main.async {
            HUD.flash(.success, delay: 0.5) { (isFinish) in
                if isFinish {
                    completion()
                }
            }
        }
    }

    class func error(completion: @escaping (Void) -> Void) {
        HUD.flash(.error, delay: 0.5) { (isFinish) in
            if isFinish {
                completion()
            }
        }
    }

    func error(message: String) {

    }

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
