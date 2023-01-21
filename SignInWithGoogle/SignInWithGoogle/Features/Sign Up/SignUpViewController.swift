//
//  SignUpViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var labelName: UITextField!
    @IBOutlet weak var labelUsername: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var labelConfirmPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signUpTouched(_ sender: Any) {
        
    }
    
    @IBAction func signInTouched(_ sender: Any) {
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
