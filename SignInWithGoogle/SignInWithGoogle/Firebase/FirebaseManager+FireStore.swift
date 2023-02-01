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
    
    func getPasswordByEmail(_ documentId: String) -> String {
        let docRef = Firestore.firestore().collection("user").document(documentId)
        
        var password = ""
        
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
                
            } else {
                if let document = document {
                    
                    if let data = document.data() {
                        password = data["password"] as? String ?? ""

                    }
                }
            }
        }
        
        return password
    }
    
//    func getPasswordByEmail(_ email: String) -> String {
//        let db = Firestore.firestore()
//
//        // Create a reference to the user collection
//        let userRef = db.collection("user")
//
//
//        // After creating a query object, use the get() function to retrieve the results:
//
//        let docRef = db.collection("user").document(email)
//
//        docRef.getDocument(as: User.self) { result in
//            // The Result type encapsulates deserialization errors or
//            // successful deserialization, and can be handled as follows:
//            //
//            //      Result
//            //        /\
//            //   Error  City
//
//
//            switch result {
//            case .success(let user):
//                // A `City` value was successfully initialized from the DocumentSnapshot.
//                print("City: \(user)")
//            case .failure(let error):
//                // A `City` value could not be initialized from the DocumentSnapshot.
//                print("Error decoding city: \(error)")
//            }
//        }
//    }
}

