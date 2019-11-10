//
//  AudioMessageCVCell.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 06.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class AudioMessageCVCell: UICollectionViewCell {
    let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    weak var delegate: CellSubclassDelegate?
    
    var leftAnchorView: NSLayoutConstraint?
    var rightAnchorView: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(view)
        view.addSubview(playButton)
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        leftAnchorView = view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        rightAnchorView = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8)
        
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOpacity = 0.7
        playButton.layer.shadowOffset = .zero
        playButton.layer.shadowRadius = 2
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playAudio(sender: UIButton!) {
        print("Play Audion")
        delegate?.buttonTapped(cell: self)
    }
}
