//
//  CellSubclassDelegate.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 07.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

protocol CellSubclassDelegate: class {
    func buttonTapped(cell: UICollectionViewCell)
}
