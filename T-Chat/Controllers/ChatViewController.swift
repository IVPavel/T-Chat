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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "back"))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9214980006, green: 0.9216085076, blue: 0.9214602709, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 2.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let recordAudioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Talk"), for: .normal)
        button.addTarget(self, action: #selector(method), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let addFielButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Article"), for: .normal)
        button.addTarget(self, action: #selector(method), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        setupTextView()
        setupUI()
        view.backgroundColor = #colorLiteral(red: 0.9214980006, green: 0.9216085076, blue: 0.9214602709, alpha: 1)
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
    
    fileprivate func setupUI() {
        view.addSubview(contentView)
        view.addSubview(tableView)
        contentView.addSubview(messageTextView)
        contentView.addSubview(sendButton)
        stackView.addArrangedSubview(addFielButton)
        stackView.addArrangedSubview(recordAudioButton)
        //contentView.addSubview(stackView)
        
        
        let margins = safeArea()
        contentView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageTextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 8).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        contentView.trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: 16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
//        contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //constraint tableView
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func safeArea() -> UILayoutGuide {
        if #available(iOS 11, *) {
            let margins = view.safeAreaLayoutGuide
            return margins
        } else {
            let margins = view.layoutMarginsGuide
            return margins
        }
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(OutgoingMessagesTVCell.self, forCellReuseIdentifier: cellIndetifireOutgoing)
        tableView.register(IncomingMessageTVCell.self, forCellReuseIdentifier: cellIndetifireIncoming)
    }
    
    fileprivate func setupTextView() {
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        self.messageTextView.delegate = self
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        ChatFBServices().sendMassege(user: user, text: messageTextView.text)
        messageTextView.text = ""
        
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
            cellOut.backgroundColor = .clear
            
            return cellOut
        } else {
            let cellInc = tableView.dequeueReusableCell(withIdentifier: cellIndetifireIncoming, for: indexPath) as! IncomingMessageTVCell
            
            cellInc.messageTextLabel.text = mass.textMessage
            cellInc.backgroundColor = .clear
            
            return cellInc
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
}


