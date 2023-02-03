//
//  Messages.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 23/01/23.
//

import FirebaseDatabase

struct Message {
    
    let ref: DatabaseReference?
    let email: String
    let text: String
    let name: String
    
    
    /// Initialize with raw data.
    init(email: String, text: String, name: String) {
        self.ref   = nil
        self.email = email
        self.text  = text
        self.name  = name
    }
    
    /// Initialize with Firebase DataSnapshot.
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let text  = value["text"] as? String,
            let name  = value["name"] as? String
        else { return nil }
        
        self.ref   = snapshot.ref
        self.email = email
        self.text  = text
        self.name  = name
    }
    
    /// Convert User to AnyObject.
    func toAnyObject() -> NSDictionary {
        
        let dictionary: NSDictionary = [
            "email" : email,
            "name" : name,
            "text": text
        ]
        
        return dictionary
    }
}
