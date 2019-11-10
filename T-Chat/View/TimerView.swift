//
//  TimerView.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 10.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class timerView: UIView {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
