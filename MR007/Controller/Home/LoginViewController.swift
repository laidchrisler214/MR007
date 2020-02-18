//
//  LoginViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 24/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class LoginViewController: BaseViewController {
    var completion: ((Void?) -> Void)? = nil

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    fileprivate var userName: String = ""
    fileprivate var password: String = ""

    fileprivate var loginNameField: UITextField? = nil
    fileprivate var mobileField: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if (self.loadUserDefault(key: Segue.register) as? Bool) != nil {
            self.removeUserDefault(key: Segue.register)
            self.performSegue(withIdentifier: "segueToRegister", sender: self)
        }
    }

    func setCallBack(callback: @escaping (Void?) -> Void) {
        self.completion = callback
    }

    @IBAction func skip () {
        if self.completion != nil {
            self.completion!(nil)
        }
    }

    @IBAction func registerAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToRegister", sender: self)
    }

    @IBAction func resetPasswordAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToResetPassword", sender: self)
    }

    @IBAction func submit() {
        guard self.isFieldNotEmpty() else {
            return
        }
        self.userName = self.userNameField.text!
        self.password =  self.passwordField.text!
        let logInRequest = LoginRequestManager()
        logInRequest.sendRequestWith(completionHandler: { (user, response) in
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
            if self.completion != nil {
                self.completion!(nil)
            }

            Answers.logCustomEvent(withName: "Log-In", customAttributes: ["loginName": user?.loginName ?? "", "email": user?.email ?? "", "lastLogInIp": user?.lastLogInIp ?? "", "balance": user?.balance ?? "" ])

        }, error: { (error) in
        }, param: self.getParams())
    }

    func textFieldDidChange() {
        guard self.isFieldNotEmpty() else {
            signUpButton.isEnabled = false
            return
        }
        signUpButton.isEnabled = true
    }

    func isFieldNotEmpty() -> Bool {
        guard userNameField.text != "" || !(userNameField.text?.isEmpty)! else {
             return false
        }
        guard passwordField.text != "" || !(passwordField.text?.isEmpty)! else {
            return false
        }
        self.userName = userNameField.text!
        self.password = passwordField.text!
        return true
    }

    @IBAction func dismissKeyBoard () {
        self.view.endEditing(true)
    }

    @IBAction func requestPassword() {
        let alert = UIAlertController(title: alertMessage.getBack, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.loginNameField = textField
        }
        alert.addTextField { (textField) in
            self.mobileField = textField
        }

        let submit = UIAlertAction(title: alertMessage.carryOn, style: .default) { (request) in
            let request = RegistrationRequestManager()
            LoadingView.nativeProgress()
            request.requestPasswordWith(completionHandler: { (user, userName) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.performSegue(withIdentifier: Segue.resetPassword, sender: userName)
                }
            }, error: { (error) in

            }, param: self.getForgotPasswordParam())
        }

        let cancel = UIAlertAction(title: alertMessage.cancel, style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(submit)
        self.present(alert, animated: true, completion: nil)
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

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(tag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.submit()
        }
        return false
    }
}

extension LoginViewController {
    func getForgotPasswordParam() -> NSDictionary {
        return ["loginName" : self.loginNameField?.text ?? "",
                "mobileNumber" : self.mobileField?.text ?? ""]
    }

    func getParams() -> NSDictionary {
        let params = ["loginName":self.userName,
                      "password":self.securePassword(password: self.password)]
        return params as NSDictionary
    }

    func securePassword(password: String) -> String {
        return password.toBase64()
    }
}
