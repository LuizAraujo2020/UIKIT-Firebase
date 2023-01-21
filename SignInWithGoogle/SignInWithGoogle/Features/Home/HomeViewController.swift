//
//  HomeViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 21/01/23.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {

    
    @IBOutlet weak var buttonSignOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signOutTouched(_ sender: UIButton) {
        print("☝🏾SIGN OUT TOUCHED")
        print("☝🏾SIGN OUT TOUCHED")
        print("☝🏾SIGN OUT TOUCHED")
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            
            /// Send back to Sign In screen
            navigationController?.popToRootViewController(animated: true)
        } catch {
            //TODO: ☑️ Tratar erro
            return
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
