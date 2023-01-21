//
//  SignInViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    
    // MARK: Constants
    let signInToSignUp = "signInToSignUp"
    let signInToHome   = "signInToHome"
    
    // MARK: Outlets
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBOutlet weak var buttonSignInGoogle: GIDSignInButton!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkSignedIn()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //
    private func checkSignedIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil && user != nil {
                /// If is already signed in, sends the app's main content View.
                  self.performSegue(withIdentifier: self.signInToHome, sender: self)
            }
        }
        
        if Auth.auth().currentUser != nil {
            /// If is already signed in, sends the app's main content View.
              self.performSegue(withIdentifier: self.signInToHome, sender: self)
        }
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
    
    
    @IBAction func signInWithGoogle(_ sender: GIDSignInButton) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
        guard error == nil else { return }

        /// If sign in succeeded, display the app's main content View.
          self.performSegue(withIdentifier: self.signInToHome, sender: self)
      }
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

// MARK: - Setups & UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    private func initialSetup() {
        
        /// Textfields delegates
        textfieldUsername.delegate = self
        textfieldPassword.delegate = self
        
        /// Sign In w/ Google
        buttonSignInGoogle.style = .wide
//        buttonSignInGoogle.colorScheme = .dark
    }
    
    private func isFormValid() -> Bool {
        //TODO: ☑️ More validations
        //TODO: ☑️ Make the Error types
        guard textfieldUsername != nil, !textfieldUsername.text!.isEmpty else { return false }
        guard textfieldPassword != nil, !textfieldPassword.text!.isEmpty else { return false }
        
        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldUsername {
            textfieldUsername.becomeFirstResponder()
        }
        
        if textField == textfieldPassword {
            textfieldPassword.resignFirstResponder()
        }
        
        return true
    }
}
