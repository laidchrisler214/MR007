//
//  ResetPasswordViewController.swift
//  MR007
//
//  Created by Roger Molas on 24/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var activationField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var activationCode = ""
    var newPassword = ""
    var confirmPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activationField.addTarget(self, action: #selector(ResetPasswordViewController.textFieldDidChange), for: .editingChanged)
        self.newPasswordField.addTarget(self, action: #selector(ResetPasswordViewController.textFieldDidChange), for: .editingChanged)
        self.confirmPasswordField.addTarget(self, action: #selector(ResetPasswordViewController.textFieldDidChange), for: .editingChanged)
    }

    func isFieldNotEmpty() -> Bool {
        guard activationField.text != "" || !(activationField.text?.isEmpty)! else {
            return false
        }
        guard newPasswordField.text != "" || !(newPasswordField.text?.isEmpty)! else {
            return false
        }
        guard confirmPasswordField.text != "" || !(confirmPasswordField.text?.isEmpty)! else {
            return false
        }

        activationCode = activationField.text!
        newPassword = newPasswordField.text!
        confirmPassword = confirmPasswordField.text!
        return true
    }

    func textFieldDidChange() {
        if self.isFieldNotEmpty() {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }

    @IBAction func submit () {
        guard isFieldNotEmpty () else {
            return
        }

        let activation = activationField.text!
        let newPass = newPasswordField.text!
        let confirmPass = confirmPasswordField.text!

        let request = RegistrationRequestManager()
        LoadingView.nativeProgress()
        request.changePasswordWith(completionHandler: { (user, response) in
            SharedUserInfo.sharedInstance.removeLoginUser()
            Alert.with(title: response, message: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                _ = self.navigationController?.popViewController(animated: true)
            }

        }, error: { (error) in

        }, param: ["verification_code": activation,
                   "new_password": newPass.toBase64(),
                   "confirm_password":confirmPass.toBase64()])
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(tag)
        if nextResponder != nil {
            self.view.endEditing(true)
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.submit()
        }
        return false
    }
}
