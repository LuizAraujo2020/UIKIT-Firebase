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

import Photos

enum References: String {
    case messages
}

class HomeViewController: ViewController, UITextFieldDelegate {
    
    var user: User?
    let ref = Database.database().reference().child("messages")
    var messages: [Message] = []
    var messagesObservers: [DatabaseHandle] = []
    
    //    var handle: AuthStateDidChangeListenerHandle?
    
    private var buttonSignOut = UIBarButtonItem()
    
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
                        print("🏆 \(messageItem.text)")
                        newItems.append(messageItem)
                    }
                }
                self.messages = newItems
                for m in self.messages {
                    print("🥳 \(m.text)")
                }
                self.table.reloadData()
            }
        messagesObservers.append(completed)
        
        //        handle = Auth.auth().addStateDidChangeListener { _, user in
        //            guard let user = user else { return }
        //            self.user = User(authData: user)
        //
        //            let currentUserRef = self.usersRef.child(user.uid)
        //            currentUserRef.setValue(user.email)
        //            currentUserRef.onDisconnectRemoveValue()
        //        }
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
        
        
        buttonSignOut = UIBarButtonItem.signOut(target: self, action: #selector(signOutTouched))
        navigationItem.rightBarButtonItem = buttonSignOut
        
        self.table.delegate   = self
        self.table.dataSource = self
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
        
        self.table.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func signOutTouched(_ sender: UIButton) {
        
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
        
        //
        //        let cell = UITableViewCell()
        //        cell.textLabel?.text = "This is row \(indexPath.row)"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let msg = messages[indexPath.row]
        print("🔄 NAME: \(msg.name) - TXXT: \(msg.text)")
        cell.textLabel?.text       = msg.text
        cell.detailTextLabel?.text = msg.name
        
        //        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfieldMessage {
            textfieldMessage.resignFirstResponder()
        }
        
        return true
    }
}
