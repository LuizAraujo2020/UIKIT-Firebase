//
//  HomeViewController.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 21/01/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

enum References: String {
    case messages
}

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var user: User?
    let ref = Database.database().reference().child("messages")
    var messages: [Message] = []
    var messagesObservers: [DatabaseHandle] = []
    
    //    var handle: AuthStateDidChangeListenerHandle?
        
    @IBOutlet weak var textfieldMessage: UITextField!
    @IBOutlet weak var buttonSignOut: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    private let cellID = "MessageTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        textfieldMessage.delegate = self
        textfieldMessage.addShadow()
        
        table.allowsMultipleSelectionDuringEditing = false
        
        setUser()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialSetup()
        
        let completed = ref
        //            .queryOrdered(byChild: "completed")
            .observe(.value) { snapshot in
                var newItems: [Message] = []
                for child in snapshot.children {
                    if
                        let snapshot = child as? DataSnapshot,
                        let messageItem = Message(snapshot: snapshot) {

                        newItems.append(messageItem)
                    }
                }
                self.messages = newItems
                self.table.reloadData()
            }
        messagesObservers.append(completed)
        
        self.user = FirebaseManager.shared.getUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        messagesObservers.forEach(ref.removeObserver(withHandle:))
        messagesObservers = []
        
        //        guard let handle = handle else { return }
        //        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    private func initialSetup() {
        
        self.table.delegate   = self
        self.table.dataSource = self
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: Methods
    private func setUser() {
        //        self.user = User(email: Auth.auth().currentUser?.email,
        //                         name: Auth.auth().currentUser?.displayName,
        //                         password: <#T##String#>)
        
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard let text = textfieldMessage.text else { return }
        
        
        let message = Message(email: FirebaseManager.shared.getUser().email,
                              text: text,
                              name: FirebaseManager.shared.getUser().name)
        
        FirebaseManager.shared.saveMessage(message)
        
        textfieldMessage.text = ""
        
        self.table.reloadData()
        
        scrollToBottom()
    }
    
    /// Scroll Table to botton
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signoutActtion(_ sender: UIBarButtonItem) {
        
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let msg = messages[indexPath.row]

        cell.textLabel?.text       = msg.text
        cell.detailTextLabel?.text = msg.email
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfieldMessage {
            textfieldMessage.resignFirstResponder()
        }
        
        return true
    }
}
