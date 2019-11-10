//
//  ChatCollectionViewController.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 06.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

private let textIdentifier = "textCell"
private let audioIdentifier = "audioCell"

class ChatCollectionViewController: UICollectionViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"back")
        image.contentMode = .scaleAspectFill
        return image
    }()
    let toolsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let hideEmptyAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2023726702, blue: 0.06828198582, alpha: 1)
        button.addTarget(self, action: #selector(startRecordAudio), for: .touchDown)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var toolsViewBottomAnchor: NSLayoutConstraint?
    var timerViewLeftAnchor: NSLayoutConstraint?
    
    var user: UserProfile? {
        didSet {
            guard let name = user?.username, let _ = user?.imageProfile, let _ = user?.email else { return }
            self.title = name
        }
    }
    var messages: Array<Message> = Array()
    
    var recordAudio = RecordAndPlayAudioMessege() /// change ?
    var timer: Timer?
    var recordTime = 0.0
    var isRuning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
        
        //download user messages
        guard let toUserId = user?.id, let currentUser = ChatFBServices().currentUser?.uid else { return }
        
        ChatFBServices().getMessages(currentUser: currentUser, toUserId: toUserId) { [weak self] (_messages) in
            self?.messages = _messages.reversed()
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeKeyboardNotification()
    }
    
    // MARK: Settings UI
    func setupCollectionView() {
        // Register cell classes
        self.collectionView.register(TextMessagesCVCell.self, forCellWithReuseIdentifier: textIdentifier)
        self.collectionView.register(AudioMessageCVCell.self, forCellWithReuseIdentifier: audioIdentifier)
        
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        self.collectionView.backgroundView = imageView
        
        // rotate collectionView to 180
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func setupUI() {
        view.addSubview(toolsView)
        view.addSubview(hideEmptyAreaView)
        toolsView.addSubview(messageTextView)
        toolsView.addSubview(timerView)
        timerView.addSubview(timeLabel)
        toolsView.addSubview(sendButton)
        
        let margins = safeArea()
        toolsView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        toolsView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        toolsViewBottomAnchor = toolsView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        toolsViewBottomAnchor!.isActive = true
        toolsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        hideEmptyAreaView.topAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        hideEmptyAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hideEmptyAreaView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        hideEmptyAreaView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        messageTextView.centerYAnchor.constraint(equalTo: toolsView.centerYAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: toolsView.leadingAnchor, constant: 16).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 8).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        toolsView.trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: 16).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        setupTimerView()
        setupCollectionView()
        setupTextView()
    }
    
    func setupTimerView() {
        timerView.topAnchor.constraint(equalTo: toolsView.topAnchor).isActive = true
        toolsView.bottomAnchor.constraint(equalTo: timerView.bottomAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: timerView.trailingAnchor).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timerView.leadingAnchor, constant: 16).isActive = true
        
        timerViewLeftAnchor = timerView.leadingAnchor.constraint(equalTo: toolsView.leadingAnchor, constant: view.frame.width)
        timerViewLeftAnchor?.isActive = true
    }
    
    fileprivate func setupTextView() {
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        self.messageTextView.delegate = self
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
    
    // MARK: Action
    @objc fileprivate func startRecordAudio() {
        guard let textWithButton = sendButton.titleLabel?.text else { return }
        if sendButton.backgroundColor == #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1) && textWithButton == "Send" {
            return
        } else {
            timerViewLeftAnchor?.constant = 0
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            if !isRuning {
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                isRuning = true
            }
            recordAudio.recordAudio()
        }
    }
    
    @objc fileprivate func sendMessage(_ sender: UIButton) {
        guard let textWithButton = sendButton.titleLabel?.text else { return }
        if sendButton.backgroundColor == #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1) && textWithButton == "Send" {
            guard let text = messageTextView.text, text != "" else { return }
            ChatFBServices().sendMessage(user: user, text: text, typeMessage: .text) { [weak self] in
                self?.collectionView.reloadData()
            }
            
            messageTextView.text = ""
            sendButton.backgroundColor = #colorLiteral(red: 1, green: 0.2023726702, blue: 0.06828198582, alpha: 1)
            sendButton.setTitle("Record", for: .normal)
            messageTextView.endEditing(true)
        } else {
            if recordTime > 0.9 {
                recordAudio.stopAudioRecord()
                ChatFBServices().sendMessage(user: user, text: "", typeMessage: .audio) { [weak self] in
                    self?.timer?.invalidate()
                    self?.recordTime = 0.0
                    self?.isRuning = false
                    self?.collectionView.reloadData()
                }
            }
            
            timerViewLeftAnchor?.constant = view.frame.width
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            
            timer?.invalidate()
            recordTime = 0.0
            isRuning = false
        }

    }
    
    @objc func updateTime() {
        recordTime += 0.1
        timeLabel.text = String(format: "%.1f", recordTime)
    }
    
    // MARK: ShowHideKeyboard
    fileprivate func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double else { return }
        
        toolsViewBottomAnchor?.constant = -keyboardFrame.height + hideEmptyAreaView.frame.height

        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: NSNotification) {
        toolsViewBottomAnchor?.constant = 0
        
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: textIdentifier, for: indexPath) as? TextMessagesCVCell
        let audioCell = collectionView.dequeueReusableCell(withReuseIdentifier: audioIdentifier, for: indexPath) as? AudioMessageCVCell
        let message = messages[indexPath.row]
        
//        switch collectionView.dequeueReusableCell(withReuseIdentifier: textIdentifier, for: indexPath) {
//        case is TextMessagesCVCell:
//            print("")
//        case is AudioMessageCVCell:
//            print("")
//        default:
//            print("")
//        }
        
        setMessageLayout(cell: textCell, message: message)
        setMessageLayout(cell: audioCell, message: message)

        switch message.typeMessage {
        case "text":
            textCell?.label.text = message.message
            return textCell!
        case "audio":
            audioCell?.delegate = self
            return audioCell!
        default:
            textCell?.label.text = message.message
            return textCell!
        }
    }
    
    ///Improve
    func setMessageLayout(cell: UICollectionViewCell?, message: Message) {
        if cell is TextMessagesCVCell {
            guard let cell = cell as? TextMessagesCVCell else { return }
            switch message.fromIdUser == ChatFBServices().currentUser?.uid {
            case true:
                cell.leftAnchorView?.isActive = false
                cell.rightAnchorView?.isActive = true
                cell.view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
            case false:
                cell.rightAnchorView?.isActive = false
                cell.leftAnchorView?.isActive = true
                cell.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
        } else {
            guard let cell = cell as? AudioMessageCVCell else { return }
            switch message.fromIdUser == ChatFBServices().currentUser?.uid {
            case true:
                cell.leftAnchorView?.isActive = false
                cell.rightAnchorView?.isActive = true
                cell.view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
            case false:
                cell.rightAnchorView?.isActive = false
                cell.leftAnchorView?.isActive = true
                cell.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
        }
    }
}

// MARK: UITextViewDelegate
extension ChatCollectionViewController: UITextViewDelegate {
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


extension ChatCollectionViewController: CellSubclassDelegate {
    func buttonTapped(cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let audioMessage = messages[indexPath.row]
        guard let url = URL(string: audioMessage.message) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                try data?.write(to: self.recordAudio.getLocalFile(), options: .atomic)
            } catch {
                print("Error: ", error)
            }
            
            self.recordAudio.palayAudio()
        }.resume()
    }
}
