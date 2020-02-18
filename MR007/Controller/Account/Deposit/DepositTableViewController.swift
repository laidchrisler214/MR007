//
//  DepositTableViewController.swift
//  MR007
//
//  Created by GreatFeat on 16/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositTableViewController: UITableViewController {

    var categories = [DepositCategoryModel]()
    var selectedCategoryId = String()
    var selectedCategory = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDepositCategories()
    }

    //MARK: - APIs
    func getDepositCategories() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.getDepositCategory(completionHandler: { (user, categories) in
            LoadingView.hide()
            self.categories = categories!
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }

    //MARK: - Helper
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToOfflineDepositMethod" {
            if let viewController = segue.destination as? DepositOfflineTableViewController {
                viewController.categoryId = self.selectedCategoryId
            }
        } else {
            if let viewController = segue.destination as? DepositOnlineTableViewController {
                viewController.categoryId = self.selectedCategoryId
                viewController.category = self.selectedCategory
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCategoryTableViewCell", for: indexPath) as? DepositCategoryTableViewCell
        cell?.setCell(data: self.categories[indexPath.row])
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    //MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategoryId = String(self.categories[indexPath.row].id)
        self.selectedCategory = self.categories[indexPath.row].category
        if self.categories[indexPath.row].category == "offline" {
            performSegue(withIdentifier: "segueToOfflineDepositMethod", sender: self)
        } else {
            performSegue(withIdentifier: "segueToOnlineDepositMethod", sender: self)
        }
    }
}
