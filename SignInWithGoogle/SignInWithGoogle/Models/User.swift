//
//  User.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 23/01/23.
//

import FirebaseDatabase

struct User: Codable {
    
//    let ref: DatabaseReference?
//    var id: String
    var email: String
    var name: String
    var password: String
    
    /// Initialize with raw data.
    init(email: String, name: String, password: String) {
//        self.ref      = nil
//        self.id       = id
        self.email    = email
        self.name     = name
        self.password = password
    }
    

    /// Initialize with Firebase DataSnapshot.
    init?(snapshot: DataSnapshot) {
        guard
            let value    = snapshot.value as? [String: AnyObject],
//            let id       = value["id"] as? String,
            let name     = value["name"] as? String,
            let email    = value["email"] as? String,
            let password = value["password"] as? String
        else { return nil }

//        self.ref      = snapshot.ref
//        self.id       = id
        self.email    = email
        self.name     = name
        self.password = password
    }
    
    /// Convert User to AnyObject.
    func toAnyObject() -> Any {
        return [
//            "id": id,
            "name": name,
            "email": email,
            "password": password
        ]
    }
}
