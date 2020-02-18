//
//  BirthSelectionViewController.swift
//  MR007
//
//  Created by GreatFeat on 12/04/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

protocol BirthSelectionDelegate: NSObjectProtocol {
    func didSelect(date: String)
}

class BirthSelectionViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: BirthSelectionDelegate? = nil
    var dateSelection = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.setDate(date!, animated: false)
    }

    @IBAction func didChangeDate(sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let value = self.datePicker.date
        self.dateSelection = dateFormatter.string(from: (value))
    }

    @IBAction func confirm() {
        if dateSelection != "" {
            self.delegate?.didSelect(date: dateSelection)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}
