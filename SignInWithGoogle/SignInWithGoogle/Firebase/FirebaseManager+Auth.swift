//
//  FirebaseManager+Auth.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 02/02/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension FirebaseManager {
    
    func signInFirebaseAuthWithEmail(_ email: String) {
        /// Checks if it is already signed in Firebase Auth
        guard Auth.auth().currentUser == nil else { return }
        
        print("🎁🎁🎁🎁🎁🎁🎁🎁")
        
        //TODO: ☑️ Throwable
        var password = ""
        /// Gets the user by the email
        
        fetchUser(email: email) { user in
            password = user.password
        }
        
        /// Auth with the received info.
        Auth.auth().signIn(withEmail: email, password: password)
        
        /// Checks again if it is already signed in Firebase Auth
        guard Auth.auth().currentUser == nil else { return }
        
        /// If the Auth doesn't happened, means that the user doesn't exists.
        password = UUID().uuidString
        Auth.auth().createUser(withEmail: email,
                               password: password) { firebaseResult, error in
            
            if let error {
                print("🐞 Error: \(error.localizedDescription)")
                
            } else {
                let temp = User(email: email,
                                name: Constants.nameAnonymous,
                                password: password)
                
                FirebaseManager.shared.addUser(user: temp)
                
                
                /// Auth with the received info.
                Auth.auth().signIn(withEmail: temp.email, password: temp.password)
                
            }
        }
        print("🎁🎁🎁🎁🎁🎁🎁🎁")
    }
    
    
    
//    func signUpFirebaseAuthWithEmailOnly(_ email: String) {
//        
//        print("🎁🎁🎁🎁🎁🎁🎁🎁")
//        
//        /// If the Auth doesn't happened, means that the user doesn't exists.
//        var password = UUID().uuidString
//        Auth.auth().createUser(withEmail: email,
//                               password: password) { firebaseResult, error in
//            
//            if let error {
//                print("🐞 Error: \(error.localizedDescription)")
//                
//            } else {
//                let temp = User(email: email,
//                                name: Constants.nameAnonymous,
//                                password: password)
//                
//                FirebaseManager.shared.addUser(user: temp)
//                
//                /// Auth with the received info.
//                Auth.auth().signIn(withEmail: temp.email, password: temp.password)
//            }
//        }
//        print("🎁🎁🎁🎁🎁🎁🎁🎁")
//    }
    
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
