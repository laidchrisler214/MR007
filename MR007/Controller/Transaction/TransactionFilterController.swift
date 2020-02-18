//
//  TransactionFilterController.swift
//  MR007
//
//  Created by GreatFeat on 05/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

protocol TransactionFilterDelegate {
    func didSelectFilter(filterType: String)
}

class TransactionFilterController: BaseViewController {

    // MARK: - PROPERTIES
    var filters = [TransactionFilterModel]()
    var delegate: TransactionFilterDelegate? = nil
    var filterType = String()

    // MARK: - OUTLETS
    @IBOutlet weak var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        filterType = String(filters[0].type)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(returnSelectedFilter))
        self.view.addGestureRecognizer(tapGesture)
        pickerView.reloadAllComponents()
        self.slideDown()
    }

    //MARK: - HELPER
    func returnSelectedFilter() {
        self.delegate?.didSelectFilter(filterType: filterType)
        self.slideUp()
    }
}

extension TransactionFilterController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filters.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(filters[row].cnLabel)
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}

extension TransactionFilterController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterType = String(filters[row].type)
    }
}
