//
//  ChangePasswordViewController.swift
//  MR007
//
//  Created by GreatFeat on 29/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var oldPasswordField: MRTextField!
    @IBOutlet weak var newPasswordField: MRTextField!
    @IBOutlet weak var confirmPasswordField: MRTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func changePasswordAction(_ sender: Any) {
        if fieldsAreValid() {
            LoadingView.nativeProgress()
            let request = RegistrationRequestManager()
            let param = getParam()
            request.changePasswordRequest(completionHandler: { (user, response) in
                LoadingView.hide()
                self.performSegueToReturnBack()
                Alert.with(title: response, message: "")
            }, error: { (error) in
                LoadingView.hide()
            }, param: param)
        }
    }

    func fieldsAreValid() -> Bool {
        if (oldPasswordField.text?.isEmpty)! || (newPasswordField.text?.isEmpty)! || (confirmPasswordField.text?.isEmpty)! {
            Alert.with(title: alertMessage.error, message: alertMessage.fieldIsEmptyError)
            return false
        }

        if (newPasswordField.text)! != (confirmPasswordField.text)! {
            Alert.with(title: alertMessage.error, message: alertMessage.passwordMustBeTheSame)
            return false
        }

        return true
    }

    func getParam() -> NSDictionary {
        let oldPassword = stringToBase64(str: oldPasswordField.text!)
        let newPassword = stringToBase64(str: newPasswordField.text!)
        let confirmPassword = stringToBase64(str: newPasswordField.text!)
        let param = ["old_password" : oldPassword, "new_password" : newPassword, "confirm_password" : confirmPassword] as NSDictionary
        return param
    }

    func stringToBase64(str: String) -> String {
        let utf8str = str.data(using: String.Encoding.utf8)
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            return base64Encoded
        }
        return String()
    }
}
