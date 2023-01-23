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
    let signUpToHome = "signUpToHome"
    
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
        
        Auth.auth().createUser(withEmail: textfieldEmail.text!, password: textfieldPassword.text!) { firebaseResult, error in
            
            if let error {
                print("🐞 Error: \(error.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: self.signUpToHome, sender: self)
            }
        }
    }
    
    @IBAction func signInTouched(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - Validations
    // TODO: ☑️ FAZER DEPOIS alerts
    //    private func validateEmail(_ field: UITextField, message: UILabel, button: UIButton? = nil) {
    //
    //        guard let text = field.text else { return }
    //
    //
    //        if text.isValidEmail() {
    //
    //            field.backgroundColor = .white
    //            message.isHidden      = true
    //
    //            //            if textfieldPassword.text?.isValidPassword() ?? false && textfieldPassword.text == textfieldConfirmPassword.text {
    //            //                buttonSignUp.isEnabled = true
    //            //            }
    //
    //        } else {
    //            field.backgroundColor = .red
    //            message.isHidden      = false
    //
    //            if let button {
    //                button.isEnabled = false
    //            }
    //        }
    //    }
    
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

        
        if let email = textfieldEmail.text,
        let pass = textfieldPassword.text,
           let confirm = textfieldConfirmPassword.text,
            email.isValidEmail(),
            pass.isValidPassword(),
           confirm == pass {
            
            buttonSignUp.isEnabled = true
            
        } else {
            buttonSignUp.isEnabled = false
        }
        
        
    }
    //        private func validateConfirmation() {
    //
    //        }
    
    
    @IBAction func textfieldNameEditing(_ sender: UITextField) {
    }
    
    
    @IBAction func textfieldEmailEditing(_ sender: UITextField) {
        validateField(sender, type: .email, message: emailMatched, button: buttonSignUp)
        
    }
    
    
    
    @IBAction func textfieldPasswordEditing(_ sender: UITextField) {
        validateField(sender, type: .password, message: passwordMatched, button: buttonSignUp)
        //        validatePassword(sender, message: emailMatched, button: buttonSignUp)
        
        
        //        if sender.text?.isValidPassword() ?? false {
        //            textfieldPassword.backgroundColor = .white
        //            passwordMatched.isHidden          = true
        //
        //            if textfieldEmail.text?.isValidEmail() ?? false && textfieldPassword.text == textfieldConfirmPassword.text {
        //                buttonSignUp.isEnabled = true
        //            }
        //        } else {
        //            textfieldPassword.backgroundColor = .red
        //            passwordMatched.isHidden          = false
        //            buttonSignUp.isEnabled            = false
        //        }
        //
        //
        //
        //        if textfieldPassword.text != textfieldConfirmPassword.text {
        //            textfieldConfirmPassword.backgroundColor = .red
        //            confirmMatched.isHidden                  = false
        //            buttonSignUp.isEnabled                   = false
        //        } else {
        //            textfieldPassword.backgroundColor = .white
        //            passwordMatched.isHidden          = true
        //        }
    }
    
    
    @IBAction func textfieldConfirmPasswordEditing(_ sender: UITextField) {
        //            guard let text = sender.text, text == textfieldPassword.text else {
        //                textfieldConfirmPassword.backgroundColor = .red
        //                confirmMatched.isHidden                  = false
        //                buttonSignUp.isEnabled                   = false
        //
        //                return
        //            }
        //
        //            textfieldConfirmPassword.backgroundColor = .white
        //            confirmMatched.isHidden                  = true
        //
        //            if textfieldEmail.text?.isValidEmail() ?? false && sender.text?.isValidPassword() ?? false {
        //                buttonSignUp.isEnabled = true
        //            }
        //        }
        
        validateField(sender, type: .confirmation, message: confirmMatched, button: buttonSignUp)
        
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
}


extension SignUpViewController {
    enum TypeOfField {
        case name, email, password, confirmation
        
        //        func validate(_ text: String) -> Bool {
        //            switch self {
        //            case .name:
        //                return true
        //
        //            case .email:
        //                return text.isValidEmail()
        //
        //            case .password:
        //                return text.isValidPassword()
        //
        //            case .confirmation:
        //                <#code#>
        //            }
        //        }
    }
}
