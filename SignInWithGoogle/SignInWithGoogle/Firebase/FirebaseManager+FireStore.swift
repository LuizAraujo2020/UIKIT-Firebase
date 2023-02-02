//
//  FirebaseManager+FireStore.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 01/02/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension FirebaseManager {
    
    // MARK: User Methods
    
    /// Create User
    func addUser(user: User) {
        let collectionRef = Firestore.firestore().collection("user")
        
//        collectionRef.document(user.email).setData(user.toAnyObject() as! [String : Any])
        
        do {
////            let newDocReference = try collectionRef.addDocument(from: user)
//            print("User stored with new document reference: \(newDocReference)")
            
            try collectionRef.document(user.email).setData(from: user)
        }
        catch {
            print(error)
        }
    }
    
    /// Gets user by the email, which is unique
    func fetchUser(email: String, setUser: @escaping (_ user: User) -> Void){
        let docRef = Firestore.firestore().collection("user").document(email)
        
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            }
            else {
                if let document = document {
                    do {
                        let tempUser = try document.data(as: User.self)
                        
                        DispatchQueue.main.async {
                            setUser(tempUser)
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
//        let db = Firestore.firestore()
//
//        db.collection("user")
//            .whereField("email", isEqualTo: "s@email.com")
//            .getDocuments(completion: { querySnapshot, err in
//
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//
//                        switch document {
//                        case .success(let user):
//                            // A User value was successfully initialized from the DocumentSnapshot.
//                            result = user
//
//                        case .failure(let error):
//                            // A User value could not be initialized from the DocumentSnapshot.
//                            print("Error decoding document: \(error.localizedDescription)")
//                        }
//
//                    }
//                }
//
//            })
//        if let us = result {
//            print("❤️❤️❤️")
//            print(us)
//        }
//        return result
    }
    
    /// Update User
    func updateUser(user: User) {
        if !user.email.isEmpty {
            let docRef = Firestore.firestore().collection("user").document(user.email)
            
            do {
                try docRef.setData(from: user)
                
            } catch {
                print(error)
            }
        }
    }
    
    func getPasswordByEmail(_ documentId: String) -> String? {
        let docRef = Firestore.firestore().collection("user").document(documentId)
        
        var password: String?
        
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
                
            } else {
                if let document = document {
                    
                    if let data = document.data() {
                        password = data["password"] as? String

                    }
                }
            }
        }
        
        return password
    }
}


/// #RESOURCES:
/// ##CRUD FIRESTORE
///     https://peterfriese.dev/posts/firestore-codable-the-comprehensive-guide/
