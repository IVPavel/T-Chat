//
//  ChatFBServices.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 22.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation
import Firebase

final class ChatFBServices {
    static var ref: DatabaseReference!
    let currentUser = Auth.auth().currentUser
    
    static func chakAuth(handler: @escaping() -> ()) {
       Auth.auth().addStateDidChangeListener { (auth, user) in
            switch user {
            case .some(_):
                print("User:: ", user!.uid)
                handler()
            case .none:
                return
            }
        }
    }
        
    fileprivate static func uploadImageProfile(compliton: @escaping(String?, Error?) -> Void) {
        let randomID = UUID.init().uuidString
        let storegeRef = Storage.storage().reference().child("ProfileImage/\(randomID).jpg")
        //change image set
        guard let image = UIImage(named: "user")?.jpegData(compressionQuality: 0.5) else { return }
        storegeRef.putData(image, metadata: nil) { (metadata, error) in
            switch metadata {
            case .some(_):
                storegeRef.downloadURL { (url, error) in
                    switch url {
                    case .some(_):
                        guard let url = url?.absoluteString else { return }
                        compliton(url, nil)
                    case .none:
                        compliton(nil, error)
                    }
                }
            case .none:
                compliton(nil, error)
            }
        }
    }
    
    func createUser(email: String, password: String, username: String, complition: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            switch authResult {
            case .some(_):
                ChatFBServices.uploadImageProfile { (url, error) in
                    switch url {
                    case .some(_):
                        guard let uid = authResult?.user.uid else { return }
                        ChatFBServices.ref = Database.database().reference()
                        ChatFBServices.ref.child("users").child(uid).setValue(["username": username, "email" : email, "imageProfile" : url])
                        complition(authResult, error)
                    case .none:
                        complition(nil, error)
                    }
                }
            case .none:
                complition(nil, error)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            switch authResult {
            case .some(_):
                print("signIn")
            case .none:
                print("ERROR:: ", error!)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: ", signOutError)
        }
    }
    
    func sendMassege(user: UserProfile?, text: String?) {
        guard let toUserId = user?.id, let currentUser = Auth.auth().currentUser?.uid else { return }
        let refFrom = Database.database().reference().child("messages").child("\(currentUser) and \(toUserId)")
        let refTo = Database.database().reference().child("messages").child("\(toUserId) and \(currentUser)")
        
        let toIdUser = toUserId
        let fromIdUser = currentUser
        let dateSend = (Date().timeIntervalSince1970)
        guard let textMessage = text, textMessage != "" else { return }
        
        let valueTo = ["textMessage" : textMessage, "toIdUser" : toIdUser, "fromIdUser" : fromIdUser, "dateSend" : dateSend] as [String : Any]
        let valueFrom = ["textMessage" : textMessage, "toIdUser" : toIdUser, "fromIdUser" : fromIdUser, "dateSend" : dateSend] as [String : Any]
        
        refTo.child("\(Date().millisecondsSince1970)").setValue(valueTo)
        refFrom.child("\(Date().millisecondsSince1970)").setValue(valueFrom)
    }
    
    func getUsers(complition: @escaping([UserProfile]?, UserProfile?) -> Void) {
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            var _users = [UserProfile]()
            var _user: UserProfile?
            for item in snapshot.children {
                let user = UserProfile(snapshot: item as! DataSnapshot)
                if Auth.auth().currentUser?.uid == user.id {
                    _user = user
                } else { _users.append(user) }
            }
            complition(_users, _user)
        })
    }
    
    func getMessages(currentUser: String, toUserId: String, compliton: @escaping([Message]) -> Void) {
        Database.database().reference().child("messages").child("\(currentUser) and \(toUserId)").observe(.value, with: { (snapshot) in
            var _message = [Message]()
            for item in snapshot.children {
                let message = Message(snapshot: item as! DataSnapshot)
                _message.append(message)
            }
            compliton(_message)
        })
    }
}
