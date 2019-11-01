//
//  IncomingMessagesTVCell.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 22.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class TextMessagesTVCell: UITableViewCell {
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var leftAnchorView: NSLayoutConstraint?
    var rightAnchorView: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUICell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUICell() {        
        contentView.addSubview(view)
        view.addSubview(messageTextLabel)
        
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        
        rightAnchorView = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8)
        leftAnchorView = view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        
        messageTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        messageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        view.bottomAnchor.constraint(equalTo: messageTextLabel.bottomAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: messageTextLabel.trailingAnchor, constant: 8).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
