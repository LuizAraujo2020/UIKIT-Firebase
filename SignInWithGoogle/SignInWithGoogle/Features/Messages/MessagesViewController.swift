//
//  MessagesViewController.swift
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

class MessagesViewController: UIViewController, UITextFieldDelegate {
    
    private(set) var user: User?
    let ref = Database.database().reference().child("messages")
    var messages: [Message] = []
    var messagesObservers: [DatabaseHandle] = []
    
    //    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var textfieldMessage: UITextField!
    @IBOutlet weak var buttonSignOut: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        textfieldMessage.delegate = self
        textfieldMessage.addShadow()
        
        table.allowsMultipleSelectionDuringEditing = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUser()
        
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
        
        table.register(MessageCustomTableViewCell.nib(),
                       forCellReuseIdentifier: MessageCustomTableViewCell.identifier)
        
        table.register(MessageAuthorCustomTableViewCell.nib(),
                       forCellReuseIdentifier: MessageAuthorCustomTableViewCell.identifier)
        
        navigationItem.hidesBackButton = true
    }
    
    
    // MARK: Methods
    func setUser() {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            
            FirebaseManager.shared.fetchUser(email: currentUserEmail) { [weak self] user in
                
                guard let self else { return }
                
                self.user = user
                
                self.table.reloadData()
            }
        }
    }
    
    /// Scrolls Table to botton
    func scrollToBottom() {
        if self.messages.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func handleMoveMessageToTrash(message: Message) {
        FirebaseManager.shared.deleteMessage(message: message)
        
        self.table.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard let text = textfieldMessage.text else { return }
        
        let message = Message(email: user?.email ?? Constants.emailAnonymous,
                              text: text,
                              name: user?.name ?? Constants.nameAnonymous)
        
        FirebaseManager.shared.saveMessage(message)
        
        textfieldMessage.text = ""
        
        self.table.reloadData()
        
        scrollToBottom()
    }
    
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

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg = messages[indexPath.row]
        
        if msg.email == user?.email {
            let customCell = tableView.dequeueReusableCell(withIdentifier: MessageAuthorCustomTableViewCell.identifier, for: indexPath) as! MessageAuthorCustomTableViewCell
            customCell.configure(title: msg.text,
                                 subtitle: msg.email)
            
            return customCell
            
        } else {
            let customCell = tableView.dequeueReusableCell(withIdentifier: MessageCustomTableViewCell.identifier, for: indexPath) as! MessageCustomTableViewCell
            customCell.configure(title: msg.text,
                                 subtitle: msg.email)
            
            return customCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard user?.email == self.messages[indexPath.row].email else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleMoveMessageToTrash(message:  (self?.messages[indexPath.row])!)
            completionHandler(true)
        }
        action.backgroundColor = UIColor.systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Prevent from editing someone else's message.
        guard messages[indexPath.row].email == user?.email else { return }
        
        /// Variable to store alertTextField
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit message", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New message."
            
            ///Copy alertTextField in local variable to use in current block of code
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { [self] action in
            messages[indexPath.row].text = textField.text ?? ""
            FirebaseManager.shared.updateMessage(messages[indexPath.row])
            ///Prints the alertTextField's value
            print(textField.text!)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textfieldMessage.resignFirstResponder()
        
        return true
    }
}
