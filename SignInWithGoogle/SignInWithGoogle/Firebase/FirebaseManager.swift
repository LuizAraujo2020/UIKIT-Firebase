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
    let referenceMessages = Database.database().reference(withPath: "messages")
    let referenceUsers    = Database.database().reference(withPath: "user")
    
    init() {}

    
    // MARK: Messages
    func saveMessage(_ message: Message) {
        //TODO: ☑️ throwable
        /// Uses the Timestamp as ID
        let timestamp = Date().currentTimeMillis()

        print("⏱️⏱️⏱️⏱️⏱️")
        print(timestamp)
        print("⏱️⏱️⏱️⏱️⏱️")
        
        referenceRoot.child("messages").child(String(timestamp)).setValue(message.toAnyObject())
    }
    
    // MARK: User Helpers
    func getUser() -> User {
        
        if let usr = userAuth {
            return User(id: usr.uid,
                        email: usr.email ?? "",
                        name: usr.displayName ?? "")
            
        } else if let usr = userGoogle {
            return User(id: usr.userID ?? "",
                        email: usr.profile?.email ?? "",
                        name: usr.profile?.name ?? "anonymous")
        }
        
        return User(id: "",
                    email: "",
                    name: "anonymous")
    }
}
