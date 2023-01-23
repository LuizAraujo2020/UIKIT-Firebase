//
//  FirebaseManager.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 23/01/23.
//

import FirebaseDatabase

class FirebaseManager {
    
    let shared = FirebaseManager()
    
    // MARK: - References
    let referenceRoot     = Database.database().reference()
    let referenceMessages = Database.database().reference(withPath: "messages")
    let referenceUsers    = Database.database().reference(withPath: "user")
    
    init() {}
    
    
    // MARK: Users
    func saveUser(_ user: User) {
        //TODO: ☑️ throwable
        referenceUsers.setValue(user.toAnyObject)
    }
    
    // MARK: Messages
    func saveMessage(_ message: Message) {
        //TODO: ☑️ throwable
        referenceUsers.setValue(message.toAnyObject)
    }
}
