//
//  SignInViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 20/01/23.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: Constants
    let signInToSignUp = "signInToSignUp"
    
    // MARK: Outlets
    @IBOutlet weak var labelUsername: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func signInTouched(_ sender: Any) {
        
    }
    
    @IBAction func signUpTouched(_ sender: Any) {
        

        performSegue(withIdentifier: signInToSignUp, sender: nil)
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
