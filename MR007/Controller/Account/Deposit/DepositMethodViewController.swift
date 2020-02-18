//
//  DepositMethodViewController.swift
//  MR007
//
//  Created by GreatFeat on 02/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

protocol DepositMethodViewControllerDelegate {
    func returnSelectedMethod(depositMethod: String)
}

class DepositMethodViewController: BaseViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData = [String]()
    var selectedMethod = String()
    var delegate: DepositMethodViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedMethod = pickerData[0]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.returnSelectedMethod))
        self.view.addGestureRecognizer(tapGesture)
        pickerView.reloadAllComponents()
        self.showAnimate()
    }

    //MARK: - HELPER
    func returnSelectedMethod() {
        self.delegate?.returnSelectedMethod(depositMethod: self.selectedMethod)
        self.removeAnimate()
    }
}

extension DepositMethodViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

extension DepositMethodViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedMethod = pickerData[row]
    }
}


