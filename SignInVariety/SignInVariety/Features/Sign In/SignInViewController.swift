//
//  SignInViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Constants
    let signInToSignUp = "signInToSignUp"
    let signInToHome   = "signInToHome"
    
    // MARK: Outlets
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        textfieldUsername.delegate = self
        textfieldPassword.delegate = self
    }
    
    
    // MARK: - Life Cycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    @IBAction func signInTouched(_ sender: UIButton) {
        if !isFormValid() { return }
        //TODO: ☑️ FAZER DEPOIS alertas
        
        Auth.auth().signIn(withEmail: textfieldUsername.text!, password: textfieldPassword.text!) { firebaseResult, error in
            
            if let error {
                print("🐞 Error: \(error.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: self.signInToHome, sender: self)
            }
        }
    }
    
    
    @IBAction func signUpTouched(_ sender: UIButton) {
        

        performSegue(withIdentifier: signInToSignUp, sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController {
    private func initialSetup() {
        
        /// Textfields delegates
        textfieldUsername.delegate = self
        textfieldPassword.delegate = self
    }
    
    private func isFormValid() -> Bool {
        //TODO: ☑️ More validations
        //TODO: ☑️ Make the Error types
        guard textfieldUsername != nil, !textfieldUsername.text!.isEmpty else { return false }
        guard textfieldPassword != nil, !textfieldPassword.text!.isEmpty else { return false }
        
        return true
    }
}
