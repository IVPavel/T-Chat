//
//  UsersTableViewController.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 21.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
    
    fileprivate let cellIdentifire = "Cell"
    var currentUser: UserProfile?
    var users = [UserProfile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ChatFBServices().getUsers { [weak self] (_users, _currentUser) in
            guard let _users = _users, let currentUser = _currentUser else { return }
            self?.users = _users
            self?.title = currentUser.username
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifire)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]

        cell.nameLabel.text = user.username
        cell.emailLabel.text = user.email

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        self.navigationController?.pushViewController(chatVC, animated: true)
        chatVC.user = users[indexPath.row]
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        ChatFBServices().signOut()
        navigationController?.popViewController(animated: true)
    }
}
