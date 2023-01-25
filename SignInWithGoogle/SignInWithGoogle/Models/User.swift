//
//  User.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 23/01/23.
//

import FirebaseDatabase

struct User {
    
    let ref: DatabaseReference?
    let id: String
    let email: String
    let name: String
//    let password: String
    
    
    /// Initialize with raw data.
    init(id: String, email: String, name: String) {
        self.ref      = nil
        self.id       = id
        self.email    = email
        self.name     = name
//        self.password = password
    }
    
//
//    /// Initialize with Firebase DataSnapshot.
//    init?(snapshot: DataSnapshot) {
//        guard
//            let value    = snapshot.value as? [String: AnyObject],
//            let name     = value["name"] as? String,
//            let email    = value["email"] as? String,
//            let password = value["password"] as? String
//        else { return nil }
//
//        self.ref      = snapshot.ref
//        self.id       = id
//        self.email    = email
//        self.name     = name
//        self.password = password
//    }
//
//    /// Convert User to AnyObject.
//    func toAnyObject() -> Any {
//        return [
//            "name": name,
//            "email": email,
//            "password": password
//        ]
//    }
}
