//
//  FirebaseManager.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 23/01/23.
//

import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private var userAuth: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    private var userGoogle: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }
    
    
    // MARK: - References
    let referenceRoot     = Database.database().reference()
    let referenceMessages = Database.database().reference().child("messages")
    let referenceUsers    = Database.database().reference(withPath: "user")
    
    // MARK: Observers
    var messagesObservers: [DatabaseHandle] = []
    
    
    init() {}
    
    // MARK: Messages
    func saveMessage(_ message: Message) {
        //TODO: ☑️ throwable
        /// Uses the Timestamp as ID
        let timestamp = Date().currentTimeMillis()
        
        referenceRoot.child("messages").child(String(timestamp)).setValue(message.toAnyObject())
    }
}
