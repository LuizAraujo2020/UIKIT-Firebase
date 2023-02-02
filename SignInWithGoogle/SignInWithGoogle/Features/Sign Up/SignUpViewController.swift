//
//  SignUpViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    // MARK: - Constants
    
    // MARK: - Outlets
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var emailMatched: UILabel!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var passwordMatched: UILabel!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var confirmMatched: UILabel!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    
    // MARK: - 🔄 Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        initialSetup()
    }
    
    
    // MARK: - Actions
    @IBAction func signUpTouched(_ sender: UIButton) {
        if !isFormValid() { return }
        
        Auth.auth().createUser(withEmail: textfieldEmail.text!,
                               password: textfieldPassword.text!) { firebaseResult, error in
            
            if let error {
                print("🐞 Error: \(error.localizedDescription)")
                
            } else {
                let temp = User(email: self.textfieldEmail.text!,
                                name: self.textfieldName.text!,
                                password: self.textfieldPassword.text!)
                
                FirebaseManager.shared.addUser(user: temp)
                
                /// Transition to the Home screen and erase fields
                self.transitionToHome()
                self.eraseAllFields()
            }
        }
    }
    
    @IBAction func signInTouched(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func textfieldEmailEditing(_ sender: UITextField) {
        
        validateField(sender, type: .email, message: emailMatched, button: buttonSignUp)
    }
    
    @IBAction func textfieldPasswordEditing(_ sender: UITextField) {
        
        validateField(sender, type: .password, message: passwordMatched, button: buttonSignUp)
    }
    
    @IBAction func textfieldConfirmPasswordEditing(_ sender: UITextField) {
        
        validateField(sender, type: .confirmation, message: confirmMatched, button: buttonSignUp)
    }
    
    
    // MARK: - Validations
    // TODO: ☑️ FAZER DEPOIS alerts
    private func validateField(_ field: UITextField, type: TypeOfField ,message: UILabel, button: UIButton? = nil) {
        
        guard let text = field.text else { return }
        
        switch type {
            
        case .name:
            break
            
        case .email:
            if text.isValidEmail() {
                
                field.backgroundColor = .white
                message.isHidden      = true
                
            } else {
                field.backgroundColor = .red
                message.isHidden      = false
            }
        case .password:
            
            if text.isValidPassword() {
                
                field.backgroundColor = .white
                message.isHidden      = true
                
            } else {
                field.backgroundColor = .red
                message.isHidden      = false
            }
            
        case .confirmation:
            if let password = textfieldPassword.text, text == password {
                field.backgroundColor = .white
                message.isHidden      = true
                
            } else {
                field.backgroundColor = .red
                message.isHidden      = false
            }
        }
        
        if let email   = textfieldEmail.text,
           let pass    = textfieldPassword.text,
           let confirm = textfieldConfirmPassword.text,
           email.isValidEmail(),
           pass.isValidPassword(),
           confirm == pass {
            
            buttonSignUp.isEnabled = true
            
        } else {
            buttonSignUp.isEnabled = false
            
        }
    }
    
    // MARK: Misc
    private func transitionToHome() {
        self.performSegue(withIdentifier: Constants.Segues.signUpToMessages, sender: self)
    }
    
    private func eraseAllFields() {
        textfieldName.text            = ""
        textfieldEmail.text           = ""
        textfieldPassword.text        = ""
        textfieldConfirmPassword.text = ""
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    private func initialSetup() {
        
        /// Textfields delegates
        textfieldName.delegate            = self
        textfieldEmail.delegate           = self
        textfieldPassword.delegate        = self
        textfieldConfirmPassword.delegate = self
        
        buttonSignUp.isEnabled = false
        
        textfieldName.addShadow()
        textfieldEmail.addShadow()
        textfieldPassword.addShadow()
        textfieldConfirmPassword.addShadow()
        buttonSignUp.addShadow()
    }
    
    private func isFormValid() -> Bool {
        //TODO: ☑️ More validations
        //TODO: ☑️ Make the Error types
        guard textfieldName != nil, !textfieldName.text!.isEmpty else { return false }
        guard textfieldEmail != nil, !textfieldEmail.text!.isEmpty else { return false }
        guard textfieldPassword != nil, !textfieldPassword.text!.isEmpty else { return false }
        guard textfieldConfirmPassword != nil, !textfieldConfirmPassword.text!.isEmpty else { return false }
        
        guard textfieldPassword.text! == textfieldConfirmPassword.text! else { return false }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfieldName {
            textfieldEmail.becomeFirstResponder()
        }
        if textField == textfieldEmail {
            textfieldPassword.becomeFirstResponder()
        }
        if textField == textfieldPassword {
            textfieldConfirmPassword.becomeFirstResponder()
        }
        if textField == textfieldConfirmPassword {
            textfieldConfirmPassword.resignFirstResponder()
        }
        
        return true
    }
}


extension SignUpViewController {
    
    enum TypeOfField {
        case name, email, password, confirmation
    }
}
