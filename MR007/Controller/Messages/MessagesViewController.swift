//
//  MessagesViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 28/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class MessagesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var messages = [MessageModel]()
    var currentIndexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem() //Setup sliding controller functions
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resquestMessages()
    }

    // Display
    func resquestMessages() {
        let request = MessageRequestManager()
        LoadingView.nativeProgress()
        request.requestMessages(completionHandler: { (user, messageList, unreadCount) in
            LoadingView.hide()
            self.messages = (messageList as? [MessageModel])!
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }

    // Delete
    func resquestDeleteMessage(message: MessageModel, indexPath: IndexPath) {
        let request = MessageRequestManager()
        LoadingView.nativeProgress()
        request.requestDeleteMessage(completionHandler: { (user, response) in
            LoadingView.hide()
            self.messages.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Alert.with(title: self.alertMessage.delete, message: response)
            }
        }, error: { (error) in
            LoadingView.hide()
        }, param: ["receiveIds":message.receiveId])
    }

    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showMessageContent {
            let destination = segue.destination as? MessageContentViewController
            let message = sender as? MessageModel
            destination?.contents.add(message ?? MessageModel())
        }
    }
}

// MARK - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageCell.getCell(tableView: tableView, idx: indexPath)
        cell.setMessage(model: messages[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = messages[indexPath.row]
        self.performSegue(withIdentifier: Segue.showMessageContent, sender: message)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        tableView.setEditing(false, animated: true)
        self.resquestDeleteMessage(message: message, indexPath: indexPath)
    }
}
