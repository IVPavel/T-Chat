//
//  AudioMessageTVCell.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 31.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class AudioMessageTVCell: UITableViewCell {

    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var leftAnchorView: NSLayoutConstraint?
    var rightAnchorView: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(view)
        view.addSubview(playButton)
        view.addSubview(progressBar)
        
        rightAnchorView = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8)
        leftAnchorView = view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        view.heightAnchor.constraint(equalToConstant: 41).isActive = true
        view.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
