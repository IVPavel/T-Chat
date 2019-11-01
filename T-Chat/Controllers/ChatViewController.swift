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
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2023726702, blue: 0.06828198582, alpha: 1)
        //button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.addTarget(self, action: #selector(startRecordAudio), for: .touchDown)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var recordAudio = RecordAndPlayAudioMessege() // изменит на ?
    fileprivate let cellIndetifireText = "TextCell"
    fileprivate let cellIndetifireAudio = "AudioCell"
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
        
        //download user messages
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
        sendButton.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
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
        tableView.register(TextMessagesTVCell.self, forCellReuseIdentifier: cellIndetifireText)
        tableView.register(AudioMessageTVCell.self, forCellReuseIdentifier: cellIndetifireAudio)
    }
    
    fileprivate func setupTextView() {
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        self.messageTextView.delegate = self
    }
    
    @objc fileprivate func startRecordAudio() {
        print("startRecordAudio")
        recordAudio.recordAudio()
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        guard let textWithButton = sendButton.titleLabel?.text else { return }
        if sendButton.backgroundColor == #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1)  && textWithButton == "Send" {
            guard let text = messageTextView.text, text != "" else { return }
            ChatFBServices().sendMessage(user: user, text: text, typeMessage: .text) {
            }
            messageTextView.text = ""
            sendButton.backgroundColor = #colorLiteral(red: 1, green: 0.2023726702, blue: 0.06828198582, alpha: 1)
            sendButton.setTitle("Record", for: .normal)
            messageTextView.endEditing(true)
        } else {
            recordAudio.stopAudioRecord()
            ChatFBServices().sendMessage(user: user, text: "", typeMessage: .audio) {
                self.tableView.reloadData()
            }
        }
        
        tableView.reloadData()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifireText, for: indexPath) as! TextMessagesTVCell
        let cellAudio = tableView.dequeueReusableCell(withIdentifier: cellIndetifireAudio, for: indexPath) as! AudioMessageTVCell
        let mass = messages[indexPath.row]
        guard let currentUser = ChatFBServices().currentUser?.uid else { return UITableViewCell() }
        
        if mass.typeMessage == "text" {
            if mass.fromIdUser == currentUser {
                cell.rightAnchorView?.isActive = true
                cell.leftAnchorView?.isActive = false
                
                cell.messageTextLabel.text = mass.message
                cell.backgroundColor = .clear
                cell.view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
                return cell
            } else {
                cell.leftAnchorView?.isActive = true
                cell.rightAnchorView?.isActive = false

                cell.messageTextLabel.text = mass.message
                cell.backgroundColor = .clear
                cell.view.backgroundColor = .white
                return cell
            }
        } else if mass.typeMessage == "audio" {
            if mass.fromIdUser == currentUser {
                cellAudio.rightAnchorView?.isActive = true
                cellAudio.leftAnchorView?.isActive = false
                cellAudio.view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
                
                cellAudio.backgroundColor = .clear
                return cellAudio
            } else {
                cellAudio.leftAnchorView?.isActive = true
                cellAudio.rightAnchorView?.isActive = false
                cellAudio.view.backgroundColor = .white
                
                cellAudio.backgroundColor = .clear
                return cellAudio
            }
        } else {
            let err = UITableViewCell()
            err.backgroundColor = .red
            return err
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text != "" {
            textView.text = nil
            textView.textColor = UIColor.black
            
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            
            sendButton.removeTarget(self, action: #selector(startRecordAudio), for: .touchDown)
            sendButton.backgroundColor = #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1)
            sendButton.setTitle("Send", for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
}


