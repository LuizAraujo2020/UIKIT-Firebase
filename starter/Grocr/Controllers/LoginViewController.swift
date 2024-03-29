/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Firebase

class LoginViewController: UIViewController {
  // MARK: Constants
  let loginToList = "LoginToList"
  
  var handle: AuthStateDidChangeListenerHandle?

  // MARK: Outlets
  @IBOutlet weak var enterEmail: UITextField!
  @IBOutlet weak var enterPassword: UITextField!

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    enterEmail.delegate = self
    enterPassword.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // You create an authentication observer that returns AuthStateDidChangeListenerHandle using addStateDidChangeListener(_:). In the block, you get two parameters: auth and user.
    handle = Auth.auth().addStateDidChangeListener { _, user in
      // Upon successful authentication, you get a valid, non-nil user; otherwise, the user is nil.
      if user == nil {
        self.navigationController?.popToRootViewController(animated: true)
      } else {
        // If you have a valid user, you perform the segue and clear the text from the text fields. It may seem strange that you don’t pass the user to the next controller, but you’ll see how to get this within GroceryListTableViewController.swift.
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
        self.enterEmail.text = nil
        self.enterPassword.text = nil
      }
    }

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    guard let handle = handle else { return }
    Auth.auth().removeStateDidChangeListener(handle)
  }

  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    performSegue(withIdentifier: loginToList, sender: nil)
    
    guard
      let email = enterEmail.text,
      let password = enterPassword.text,
      !email.isEmpty,
      !password.isEmpty
    else { return }

    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error, user == nil {
        let alert = UIAlertController(
          title: "Sign In Failed",
          message: error.localizedDescription,
          preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
      }
    }

  }

  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    performSegue(withIdentifier: loginToList, sender: nil)
    
    // Get the email and password as supplied by the user from the alert controller.
    guard
      let email = enterEmail.text,
      let password = enterPassword.text,
      !email.isEmpty,
      !password.isEmpty
    else { return }

    // Call createUser(withEmail:password:completion:) on the Firebase auth object passing the email, password and completion block.
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
      // If there are no errors, Firebase created the user account. However, you still need to authenticate this new user, so you call signIn(withEmail:password:), again passing in the supplied email and password.
      if error == nil {
        Auth.auth().signIn(withEmail: email, password: password)
      } else {
        print("Error in createUser: \(error?.localizedDescription ?? "")")
      }
    }

  }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  11- iOS obfuscation
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == enterEmail {
      enterPassword.becomeFirstResponder()
    }

    if textField == enterPassword {
      textField.resignFirstResponder()
    }
    return true
  }
}
