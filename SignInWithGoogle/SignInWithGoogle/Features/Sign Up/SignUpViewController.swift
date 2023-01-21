//
//  SignUpViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    
    // MARK: 🔄 Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        /// Textfields delegates
        textfieldName.delegate            = self
        textfieldUsername.delegate        = self
        textfieldPassword.delegate        = self
        textfieldConfirmPassword.delegate = self
        
    }
    
    
    // MARK: Actions
    @IBAction func signUpTouched(_ sender: UIButton) {
        
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
