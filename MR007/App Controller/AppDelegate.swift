//
//  AppDelegate.swift
//  MR007
//
//  Created by Dwaine Alingarog on 22/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var networkView:UIView? = nil
    var window: UIWindow?
    let viewControllerManager:ViewControllerManager = ViewControllerManager.sharedInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Buddy Build CI
        BuddyBuildSDK.setup()
        //Initialize fabric with crashlytics
        Fabric.with([Crashlytics.self])
        Fabric.with([Answers.self])
        //set navigation bar and item color properties
        let hexColorConverter = HexColorConverter()
        UINavigationBar.appearance().barTintColor = hexColorConverter.UIColorFromHex(hexValue: 0x0B7DB1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false
        //remove all back button titles
        let barAppearace = UIBarButtonItem.appearance()
        if #available(iOS 11, *) {
            barAppearace.setBackButtonTitlePositionAdjustment(
                UIOffsetMake(-210, 0), for:UIBarMetrics.default)
        } else {
            barAppearace.setBackButtonTitlePositionAdjustment(
                UIOffsetMake(0, -80), for:UIBarMetrics.default)
        }

         self.setUpView()

        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func setUpView() {
        let storyboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        let rootView = viewControllerManager.getSlideViewController()
        storyboard.instantiateViewController(withIdentifier: StoryboardId.rootView)
        //let user = SharedUserInfo.sharedInstance
        self.window?.rootViewController = rootView
        self.window?.makeKeyAndVisible()
//        if user.isLogIn() {
//            //Setup main view controller with slide menu
//
//        } else {
//            let login = storyboard.instantiateViewController(withIdentifier: StoryboardId.login) as? LoginViewController
//            login?.setCallBack(callback: { (action) in
//                self.window?.rootViewController = rootView
//                self.window?.makeKeyAndVisible()
//            })
//            let navigation = UINavigationController(rootViewController: login!)
//            self.window?.rootViewController = navigation
//            self.window?.makeKeyAndVisible()
        //}
    }

    // MARK: Global call
    func showNetworkError() { // Network notifier
        if self.networkView == nil {
            let duaration = 2.25
            let navFrame = self.window?.rootViewController?.view.frame
            let vframe = CGRect(x: (navFrame?.origin.x)!, y: ((navFrame?.minY)! + 65), width: (navFrame?.size.width)!, height: 30.0)
            self.networkView = UIView(frame: vframe)

            let label = UILabel(frame: (networkView?.bounds)!)
            label.text = "No Internet Connection"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12.0)

            self.networkView?.addSubview(label)
            self.networkView?.backgroundColor = UIColor.white
            self.networkView?.alpha = 0.0

            UIView.animate(withDuration: duaration, animations: {
                self.networkView?.alpha = 1.0
                self.window?.rootViewController?.view.bringSubview(toFront: self.networkView!)
                self.window?.rootViewController?.view.addSubview(self.networkView!)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: duaration, animations: {
                        self.networkView?.alpha = 0.0
                        self.networkView?.removeFromSuperview()
                        self.networkView = nil
                    })
                }
            })
        }
    }

    func sessionExpired() {
        viewControllerManager.resetView { (Void) in
        }
    }

    func showVersionUpdateScreen(urlString: String) {
        let storyBoard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: StoryboardId.versionUpdate) as? VersionUpdateViewController
        view?.urlstring = urlString
        self.window?.rootViewController?.present(view!, animated: true, completion: nil)
        LoadingView.hide()
    }

    func showMaintenanceScreen() {
        let storyBoard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: StoryboardId.maintenance)
        self.window?.rootViewController?.present(view, animated: true, completion: nil)
        LoadingView.hide()
    }

    func globalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = Alert().okButton(action: nil)
        alert.addAction(action)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        LoadingView.hide()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
