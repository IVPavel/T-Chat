//
//  TextMessagesCVCell.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 06.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class TextMessagesCVCell: UICollectionViewCell {
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8882181644, green: 0.9984032512, blue: 0.7793390155, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var leftAnchorView: NSLayoutConstraint?
    var rightAnchorView: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(view)
        view.addSubview(label)
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.frame.width / 1.5).isActive = true
        
        leftAnchorView = view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        rightAnchorView = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
