//
//  AlertViewOptions.swift
//  MR007
//
//  Created by Roger Molas on 10/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

protocol AlertViewOptionsDelegate: NSObjectProtocol {
    func didSelect<T>(item: T, option: AlertViewOptions)
}

class AlertViewOptions: UIAlertController {
    weak var delegate: AlertViewOptionsDelegate? = nil
    var contents = [Any]()
    fileprivate var tableView: UITableView? = nil
    let alertMessage = AlertMessage()

    func setUpView() {
        let viewcontroller = UIViewController()
        var rect = CGRect.zero

        if contents.count < 4 {
            rect = CGRect(x: 0, y: 0, width: 272, height: 100)
            viewcontroller.preferredContentSize = rect.size

        } else if contents.count < 6 {
            rect = CGRect(x: 0, y: 0, width: 272, height: 150)
            viewcontroller.preferredContentSize = rect.size

        } else if contents.count < 8 {
            rect = CGRect(x: 0, y: 0, width: 272, height: 200)
            viewcontroller.preferredContentSize = rect.size

        } else {
            rect = CGRect(x: 0, y: 0, width: 272, height: 250)
            viewcontroller.preferredContentSize = rect.size
        }

        self.tableView = UITableView(frame: rect)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.allowsSelection = true
        self.tableView?.isUserInteractionEnabled = true

        viewcontroller.view.isUserInteractionEnabled = true
        viewcontroller.view.addSubview(self.tableView!)
        viewcontroller.view.bringSubview(toFront: self.tableView!)
        self.setValue(viewcontroller, forKey: "contentViewController")

        let action = UIAlertAction(title: alertMessage.cancel, style: .cancel, handler: nil)
        self.addAction(action)
    }
}

// MARK: - UITableViewDataSource
extension AlertViewOptions: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell()
        }
        // Down cast object
        let object = contents[indexPath.row]
        let newObject = object as AnyObject

        // Check object type
        if newObject.isKind(of: BankModel.self) {
            let bankName = (object as? BankModel)?.bankName
            let accountName = (object as? BankModel)?.accountName
             cell?.textLabel?.text = "\(bankName!): \(accountName!)"
        }
        // Check object type
        if newObject.isKind(of: FilterModel.self) {
            let filter = (newObject as? FilterModel)?.enLabel
            cell?.textLabel?.text = "\(filter!)"
        }

        if newObject.isKind(of: NSString.self) {
            cell?.textLabel?.text = "\(newObject)"
        }
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension AlertViewOptions: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let selectedItem = contents[indexPath.row]
        self.delegate?.didSelect(item: selectedItem, option: self)
    }
}
