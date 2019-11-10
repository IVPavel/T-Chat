//
//  ChatFBServices.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 22.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

final class ChatFBServices {
    static var ref: DatabaseReference!
    let currentUser = Auth.auth().currentUser
    let storegeRef = Storage.storage().reference()
    
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
    
    private func uploadAudioMessage(user: UserProfile?, compliton: @escaping(URL) -> Void) {
        let localFile = RecordAndPlayAudioMessege().getLocalFile()
        guard let toUserId = user?.id, let currentUser = ChatFBServices().currentUser else { return }
        let ref = storegeRef.child("\(currentUser.uid) and \(toUserId)").child("Audio Message/\(Date().millisecondsSince1970).m4a")
        
        let task = ref.putFile(from: localFile, metadata: nil) { (metadata, error) in
            switch metadata {
            case .some(_):
                ref.downloadURL { (url, error) in
                    switch url {
                    case .some(_):
                        guard let url = url else { return }
                        compliton(url)
                    case .none:
                        print("URL not found", error!)
                    }
                }
            case .none:
                print("File not found::", error!)
            }
        }
        
        task.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress?.fractionCompleted else { return }
            print("Progress:: ", progress)
        }
    }
    
    func sendMessage(user: UserProfile?, text: String?, typeMessage: TypeMessage, complition: @escaping() -> Void) {
        guard let toUserId = user?.id,
            let currentUser = ChatFBServices().currentUser?.uid,
            var mess = text else { return }
        let refFrom = Database.database().reference().child("messages").child("\(currentUser) and \(toUserId)")
        let refTo = Database.database().reference().child("messages").child("\(toUserId) and \(currentUser)")
        
        var type = String()
        var message: Message?
        
        let date = Date().millisecondsSince1970
        
        switch typeMessage {
        case .text:
            type = "text"
            message = Message(typeMessage: type,
            toIdUser: toUserId,
            fromIdUser: currentUser,
            date: Date().timeIntervalSince1970,
            message: mess)
        case .audio:
            type = "audio"
            self.uploadAudioMessage(user: user) { (urlAudio)  in
                mess = urlAudio.absoluteString
                message = Message(typeMessage: type,
                                  toIdUser: toUserId,
                                  fromIdUser: currentUser,
                                  date: Date().timeIntervalSince1970,
                                  message: mess)
                
                let date1 = date
                
                refTo.child("\(date1)").setValue(message?.convertToDictionary())
                refFrom.child("\(date1)").setValue(message?.convertToDictionary())
                complition()
            }
        }
        
        refTo.child("\(date)").setValue(message?.convertToDictionary())
        refFrom.child("\(date)").setValue(message?.convertToDictionary())
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
