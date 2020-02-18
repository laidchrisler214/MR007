//
//  RequestResetPassword.swift
//  MR007
//
//  Created by GreatFeat on 02/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class RequestResetPassword: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var resetMediumField: UITextField!

    //MARK: PROPERTIES
    var isMobile = Bool()
    let request = RegistrationRequestManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        isMobile = false
        self.addGestureToSuperViewForDismissingKeyboard()
        self.tabBarController?.tabBar.isHidden = true
    }

    //MARK: API
    func requestResetPassword() {

    }

    //MARK: HELPER
    func addGestureToSuperViewForDismissingKeyboard(){
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    func dismissKeyboard(){
        self.view.endEditing(true);
    }

    //MARK: BUTTON ACTIONS
    @IBAction func EmailSelected(_ sender: Any) {
        emailButton.setImage(#imageLiteral(resourceName: "blueMailIcon"), for: .normal)
        phoneButton.setImage(#imageLiteral(resourceName: "grayPhoneIcon"), for: .normal)
        emailLabel.textColor = self.hexColor.UIColorFromHex(hexValue: 0x0B7DB1)
        phoneLabel.textColor = self.hexColor.UIColorFromHex(hexValue: 0x969696)
        resetMediumField.placeholder = "  请输入您无法登录的账号注册邮箱"
        resetMediumField.keyboardType = UIKeyboardType.emailAddress
        isMobile = false
        resetMediumField.text = ""
        dismissKeyboard()
    }

    @IBAction func PhoneSelected(_ sender: Any) {
        emailButton.setImage(#imageLiteral(resourceName: "grayMailIcon"), for: .normal)
        phoneButton.setImage(#imageLiteral(resourceName: "bluePhoneIcon"), for: .normal)
        emailLabel.textColor = self.hexColor.UIColorFromHex(hexValue: 0x969696)
        phoneLabel.textColor = self.hexColor.UIColorFromHex(hexValue: 0x0B7DB1)
        resetMediumField.placeholder = "  请输入您无法登录的账号注册手机号码"
        resetMediumField.keyboardType = UIKeyboardType.phonePad
        isMobile = true
        resetMediumField.text = ""
        dismissKeyboard()
    }

    @IBAction func SubmitAction(_ sender: Any) {
        LoadingView.nativeProgress()
        var mediumFieldKey = String()
        if isMobile {
            mediumFieldKey = "mobile"
        } else {
            mediumFieldKey = "email"
        }
        let params = ["loginName": userNameField.text!, "isMobile": String(isMobile), mediumFieldKey:resetMediumField.text!] as NSDictionary
        request.requestPasswordWith(completionHandler: { (user, username) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.performSegue(withIdentifier: Segue.resetPassword, sender: username)
            }
        }, error: { (error) in
            LoadingView.hide()
        }, param: params)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.resetPassword {
            let logInName = (sender as? String)!
            let user = SharedUserInfo.sharedInstance
            user.setUser(loginName: logInName)
        }

        if let destination =  segue.destination as? RegistrationViewController {
            destination.finishedCallback = {(isFinished) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
