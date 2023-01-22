//
//  SignUpViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Constants
    let signUpToHome = "signUpToHome"
    
    // MARK: - Outlets
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    
    // MARK: - 🔄 Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func signUpTouched(_ sender: UIButton) {
        if !isFormValid() { return }
        
        Auth.auth().createUser(withEmail: textfieldUsername.text!, password: textfieldPassword.text!) { firebaseResult, error in
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpViewController {
    private func initialSetup() {
        
        /// Textfields delegates
        textfieldName.delegate            = self
        textfieldUsername.delegate        = self
        textfieldPassword.delegate        = self
        textfieldConfirmPassword.delegate = self
    }
    
    private func isFormValid() -> Bool {
        //TODO: ☑️ More validations
        //TODO: ☑️ Make the Error types
        guard textfieldName != nil, !textfieldName.text!.isEmpty else { return false }
        guard textfieldUsername != nil, !textfieldUsername.text!.isEmpty else { return false }
        guard textfieldPassword != nil, !textfieldPassword.text!.isEmpty else { return false }
        guard textfieldConfirmPassword != nil, !textfieldConfirmPassword.text!.isEmpty else { return false }

        guard textfieldPassword.text! == textfieldConfirmPassword.text! else { return false }
        
        return true
    }
}
