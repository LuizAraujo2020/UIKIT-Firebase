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
    
    // MARK: Outlets
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var emailMatched: UILabel!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var passwordMatched: UILabel!
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
    
    
    private func checkSignedIn() {
        
        if Auth.auth().currentUser != nil {
            /// If is already signed in, sends the app's main content View.
            self.performSegue(withIdentifier: Constants.Segues.signInToMessages, sender: self)
            print("🟥 SIGNED IN WITH FIREBASE")
        } else {
            
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                
                if error == nil && user != nil {
                    /// If is already signed in with `Google`, signs in with Firebase Auth and sends the app's main content View.
                    print("🟥 SIGNED IN WITH Google: \(user?.profile?.email ?? "aaaaaa")")
                    FirebaseManager.shared.signInFirebaseAuthWithEmail(user?.profile?.email ?? "")
                    print("🟥 SIGNED IN WITH Google -> FIREBASE AUTH: \(Auth.auth().currentUser?.email ?? "aasasaaa")")
                    self.performSegue(withIdentifier: Constants.Segues.signInToMessages, sender: self)
                }
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func signInTouched(_ sender: UIButton) {
        
        /// Sign in the user
        Auth.auth().signIn(withEmail: textfieldEmail.text!, password: textfieldPassword.text!) { firebaseResult, error in
            
            if let error {
                print("🐞 Error: \(error.localizedDescription)")
                
            } else {
                self.eraseAllFields()
                self.performSegue(withIdentifier: Constants.Segues.signInToMessages, sender: self)
            }
        }
    }
    
    @IBAction func signUpTouched(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.signInToSignUp, sender: self)
    }
    
    
    @IBAction func signInWithGoogle(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            guard error == nil else { return }
            
            /// Gets the email from the Google and retrieves the password from FireStore.
            let email = signInResult?.user.profile?.email ?? Constants.emailAnonymous
            var password = ""
            
            FirebaseManager.shared.fetchUser(email: email) { user in
                password = user.password
            }
            /// Gets the password and signs in the Firebase Auth.
            Auth.auth().signIn(withEmail: email, password: password)
            
            /// If sign in succeeded, display the app's main content View.
            self.performSegue(withIdentifier: Constants.Segues.signInToMessages, sender: self)
        }
    }
    
    
    // MARK: - Validations
    // TODO: ☑️ FAZER DEPOIS alerts
    @IBAction func textfieldEmailEditing(_ sender: UITextField) {
        
        if sender.text?.isValidEmail() ?? false {
            textfieldEmail.backgroundColor = .white
            emailMatched.isHidden          = true
            
            if textfieldPassword.text?.isValidPassword() ?? false {
                buttonSignIn.isEnabled = true
            }
        } else {
            textfieldEmail.backgroundColor = .red
            emailMatched.isHidden          = false
            buttonSignIn.isEnabled         = false
            
        }
    }
    
    @IBAction func textfieldPasswordEditing(_ sender: UITextField) {
        
        if sender.text?.isValidPassword() ?? false {
            textfieldPassword.backgroundColor = .white
            passwordMatched.isHidden          = true
            
            if textfieldEmail.text?.isValidEmail() ?? false {
                buttonSignIn.isEnabled = true
            }
        } else {
            textfieldPassword.backgroundColor = .red
            passwordMatched.isHidden          = false
            buttonSignIn.isEnabled            = false
        }
    }
    
    private func eraseAllFields() {
        textfieldEmail.text    = ""
        textfieldPassword.text = ""
    }
}

// MARK: - Setups & UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    private func initialSetup() {
        
        /// Textfields delegates
        textfieldEmail.delegate = self
        textfieldEmail.addShadow()
        textfieldPassword.delegate = self
        textfieldPassword.addShadow()
        
        buttonSignIn.addShadow()
        
        /// Sign In w/ Google
        buttonSignInGoogle.style = .wide
        
        emailMatched.isHidden    = true
        passwordMatched.isHidden = true
        buttonSignIn.isEnabled   = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldEmail {
            textfieldEmail.becomeFirstResponder()
        }
        
        if textField == textfieldPassword {
            textfieldPassword.resignFirstResponder()
        }
        
        return true
    }
}
