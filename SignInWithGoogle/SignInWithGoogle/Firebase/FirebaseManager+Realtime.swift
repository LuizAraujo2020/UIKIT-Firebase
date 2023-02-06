//
//  FirebaseManager+Realtime.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 04/02/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension FirebaseManager {
    
    // MARK: Messages
    
    /// Save Message
    func saveMessage(_ message: Message) {
        //TODO: ☑️ throwable
        /// Uses the Timestamp as ID
        let timestamp = Date().currentTimeMillis()
        
        referenceRoot.child("messages").child(String(timestamp)).setValue(message.toAnyObject())
    }
    
    /// Update Message
    func updateMessage(_ message: Message) {
        //TODO: ☑️ throwable
        
        message.ref?.setValue(message.toAnyObject())
    }
    
    /// Delete Messages
    func deleteMessage(message: Message) {
        //TODO: ☑️ throwable
        
        message.ref?.removeValue()
    }
}
