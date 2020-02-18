//
//  MessageContentViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 08/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class MessageContentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var contents = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 500
        self.tableView.reloadData()
        let message = contents[0] as? MessageModel
        self.readMessage(message: message!)

        let leftButton: UIBarButtonItem = UIBarButtonItem(title:"删除",
                                                          style: .plain,
                                                          target: self,
                                                          action: nil)
        navigationItem.rightBarButtonItem = leftButton
    }

    // Delete
    func readMessage(message: MessageModel) {
        let request = MessageRequestManager()
        request.readMessage(completionHandler: { (user, response) in
            print(response)
        }, error: { (error) in
        }, param: ["receiveId":message.receiveId])
    }
}

extension MessageContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageContentTableViewCell.getCell(tableView: tableView, idx: indexPath)
        cell.setContent(message: (contents[indexPath.row] as? MessageModel)!)
        return cell
    }
}
