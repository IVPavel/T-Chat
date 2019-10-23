//
//  ChatViewController.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 22.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    fileprivate let cellIndetifireOutgoing = "Cell_Outgoing"
    fileprivate let cellIndetifireIncoming = "Cell_Incoming"
    var user: UserProfile? {
        didSet {
            guard let name = user?.username, let _ = user?.imageProfile, let _ = user?.email else { return }
            self.title = name
        }
    }
    var messages: Array<Message> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let toUserId = user?.id, let currentUser = ChatFBServices().currentUser?.uid else { return }
        
        ChatFBServices().getMessages(currentUser: currentUser, toUserId: toUserId) { [weak self] (_messages) in
            self?.messages = _messages
            self?.tableView.reloadData()
            
            guard let messCount = self?.messages.count else { return }
            if messCount > 0 {
                self?.tableView.scrollToBottom()
            } else {
                return
            }
        }
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(OutgoingMessagesTVCell.self, forCellReuseIdentifier: cellIndetifireOutgoing)
        tableView.register(IncomingMessageTVCell.self, forCellReuseIdentifier: cellIndetifireIncoming)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        ChatFBServices().sendMassege(user: user, text: messageTextField.text)
        messageTextField.text = ""
        
        tableView.reloadData()
        tableView.scrollToBottom()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mass = messages[indexPath.row]
        guard let currentUser = ChatFBServices().currentUser?.uid else { return UITableViewCell() }
        
        if mass.fromIdUser == currentUser {
            let cellOut = tableView.dequeueReusableCell(withIdentifier: cellIndetifireOutgoing, for: indexPath) as! OutgoingMessagesTVCell
            
            cellOut.messageTextLabel.text = mass.textMessage
            
            return cellOut
        } else {
            let cellInc = tableView.dequeueReusableCell(withIdentifier: cellIndetifireIncoming, for: indexPath) as! IncomingMessageTVCell
            
            cellInc.messageTextLabel.text = mass.textMessage
            
            return cellInc
        }
    }
}
