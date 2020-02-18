//
//  RegistrationViewController.swift
//  MR007
//
//  Created by Roger Molas on 15/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import ActionSheetPicker_3_0
import UIKit
import Crashlytics

// API Response Keys
fileprivate enum Response: String {
    case message    = "message"
}

// API Param Keys
fileprivate enum Param: String {
    case loginName  = "loginName"
    case fullName   = "fullName"
    case password   = "userPassword"
    case cPassword  = "confirmUserPassword"
    case birthday   = "birthday"
    case gender     = "gender"
    case email      = "email"
    case mobile     = "mobile"
    case confirmed  = "confirmed"
}

class RegistrationViewController: BaseViewController {
    let backgroundColor = UIColor.init(colorLiteralRed: 11/225, green: 125/225, blue: 177/225, alpha: 1.0)

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginNameField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmedPasswordField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var termsView: UIView!

    var activeField: UITextField? = nil
    var finishedCallback:((_ isFinished: Bool) -> Void)?

    var isConfirm: Bool = false

    fileprivate var loginName: String = ""
    fileprivate var fullName: String = ""
    fileprivate var password: String = ""
    fileprivate var confirmedPassword: String = ""
    fileprivate var birthday: String = ""
    fileprivate var gender: String = ""
    fileprivate var email: String = ""
    fileprivate var mobile: String = ""

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.hideKeyboad))
        self.scrollView.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(tap)

        self.loginNameField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.fullNameField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.birthdayField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.mobileField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.emailField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)
        self.confirmedPasswordField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange), for: .editingChanged)

//        self.maleButton.isUserInteractionEnabled = true
//        self.femaleButton.isUserInteractionEnabled = true
//        self.scrollView.isUserInteractionEnabled = true
        self.toggleGenderMale()

        // Register
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RegistrationViewController.keyboardWasShown(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RegistrationViewController.keyboardWillBeHidden),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo as? [String:Any?]
        let keyboardRect = info?[UIKeyboardFrameBeginUserInfoKey] as? CGRect
        let kbSize = keyboardRect?.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (kbSize?.height)!, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let aRect = self.view.frame
        if !aRect.contains((activeField?.frame.origin)!) {
            let scrollPoint = CGPoint(x: 0.0, y: (activeField?.frame.origin.y)! - (kbSize?.height)!)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }

    func keyboardWillBeHidden() {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @IBAction func hideKeyboad () {
        self.view.endEditing(true)
    }

    @IBAction func confirmed () {
        self.isConfirm = true
        if self.isFieldNotEmpty() {
            signUpButton.isEnabled = true
        }
    }

    @IBAction func registerAction(_ sender: Any) {
        if isPhoneValid() {
            let param = generateParametters()
            let registrationRequest = RegistrationRequestManager()
            LoadingView.nativeProgress()
            registrationRequest.sendRequestWith(completionHandler: { (user, response) in
                LoadingView.hide()

                Answers.logCustomEvent(withName: "Register", customAttributes: ["loginName": user?.loginName ?? "", "email": user?.email ?? "", "lastLogInIp": user?.lastLogInIp ?? "", "balance": user?.balance ?? "", "response": response ?? "" ])

                _ = self.navigationController?.popViewController(animated: true)

                let alert = Alert.registrationAlert(title: response)
                let action = Alert().okButton(action: { (action) in
                    DispatchQueue.main.async {
                        self.finishedCallback!(true)
                    }
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

            }, error: { (error) in
                LoadingView.hide()

            }, param: param as NSDictionary?)
        } else {
            Alert.with(title: alertMessage.error, message: alertMessage.invalidPhoneError)
        }
    }

    @IBAction func toggleGenderMale() {
        self.maleButton.isSelected = true
        self.maleButton.backgroundColor = backgroundColor
        self.maleButton.setImage(#imageLiteral(resourceName: "maleIcon2"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "femaleIcon"), for: .normal)
        self.gender = "MR"

        self.femaleButton.isSelected = false
        self.femaleButton.backgroundColor = UIColor.white
    }

    @IBAction func toggleGenderFemale() {
        self.femaleButton.isSelected = true
        self.femaleButton.backgroundColor = backgroundColor
        self.femaleButton.setImage(#imageLiteral(resourceName: "femaleIcon2"), for: .normal)
        self.maleButton.setImage(#imageLiteral(resourceName: "maleIcon"), for: .normal)
        self.gender = "MS"

        self.maleButton.isSelected = false
        self.maleButton.backgroundColor = UIColor.white
    }

    func isFieldNotEmpty() -> Bool {
        guard loginNameField.text != "" || !(loginNameField.text?.isEmpty)! else {
            return false
        }
        guard fullNameField.text != "" || !(fullNameField.text?.isEmpty)! else {
            return false
        }
        guard birthdayField.text != "" || !(birthdayField.text?.isEmpty)! else {
            return false
        }
        guard mobileField.text != "" || !(mobileField.text?.isEmpty)! else {
            return false
        }
        guard emailField.text != "" || !(emailField.text?.isEmpty)! else {
            return false
        }
        guard passwordField.text != "" || !(passwordField.text?.isEmpty)! else {
            return false
        }
        guard confirmedPasswordField.text != "" || !(confirmedPasswordField.text?.isEmpty)! else {
            return false
        }
        guard isConfirm else {
            return false
        }

        loginName = loginNameField.text!
        fullName = fullNameField.text!
        password = passwordField.text!
        confirmedPassword = confirmedPasswordField.text!
        birthday = birthdayField.text!
        email = emailField.text!
        mobile = mobileField.text!
        return true
    }

    func isPhoneValid() -> Bool {
        guard (mobileField.text?.count)! < 11 || (mobileField.text?.count)! > 11  else {
            return false
        }
        return true
    }

    func textFieldDidChange() {
        if self.isFieldNotEmpty() {
            signUpButton.isEnabled = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? BirthSelectionViewController
        destination?.delegate = self
    }
/*
    func didSelectBirthField() {
        let datePicker = ActionSheetDatePicker(title: LAlert.date.rawValue,
                                               datePickerMode: .date,
                                               selectedDate: Date(),
                                               doneBlock: { (picker, value, index) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthdayField.text = "\(dateFormatter.string(from: (value as? Date)!))"
        }, cancel: { (picker) in

        }, origin: self.view)
        datePicker?.show()
    }

    func didSelectGenderField() {
        ActionSheetStringPicker.show(withTitle: LAlert.gender.rawValue,
                                     rows: genderList,
                                     initialSelection: 1,
                                     doneBlock: { picker, value, index in
            self.genderField.text = "\(genderList[value])"
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
    }
*/
    @IBAction func moveUpAction(_ sender: Any) {
        scrollViewHeight.constant = CGFloat(470)
        termsView.isHidden = true
    }

    @IBAction func expandAction(_ sender: Any) {
        scrollViewHeight.constant = CGFloat(1151)
        termsView.isHidden = false
    }

}

// MARK: - BirthSelectionDelegate
extension RegistrationViewController: BirthSelectionDelegate {
    internal func didSelect(date: String) {
        self.birthdayField.text = date
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeField = textField
        self.view.endEditing(true)
        if textField.tag == 3 {
            self.performSegue(withIdentifier: Segue.showBirth, sender: nil)
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(tag)
        if nextResponder != nil {
            self.view.endEditing(true)
            if textField.tag == 3 {
                self.performSegue(withIdentifier: Segue.showBirth, sender: nil)
            }
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - Generate parameters
extension RegistrationViewController {
    func generateParametters() -> [String:Any?] {
        return [Param.loginName.rawValue: self.loginName,
                Param.fullName.rawValue : self.fullName,
                Param.password.rawValue : self.password.toBase64(),
                Param.cPassword.rawValue: self.confirmedPassword.toBase64(),
                Param.birthday.rawValue : self.birthday,
                Param.gender.rawValue   : self.gender,
                Param.email.rawValue    : self.email,
                Param.mobile.rawValue   : self.mobile,
                Param.confirmed.rawValue: isConfirm]
    }
}


