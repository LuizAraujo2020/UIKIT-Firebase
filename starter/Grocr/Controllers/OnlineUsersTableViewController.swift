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

class OnlineUsersTableViewController: UITableViewController {
  // MARK: Constants
  let userCell = "UserCell"

  // MARK: Properties
  var currentUsers: [String] = []
  
  let usersRef = Database.database().reference(withPath: "online")
  var usersRefObservers: [DatabaseHandle] = []

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    // Create an observer that listens for changes in usersRef, when a new child is added. This is different than observing a value change because it only passes the added child to the closure.
    let childAdded = usersRef
      .observe(.childAdded) { [weak self] snap in
        // Take the value from the snapshot and append it to the local array.
        guard
          let email = snap.value as? String,
          let self = self
        else { return }
        self.currentUsers.append(email)
        // You’re going to add a new row. The new row index is the count of the local array minus one because the indexes managed by the table view are zero-based.
        let row = self.currentUsers.count - 1
        // Create the corresponding NSIndexPath using the calculated row index.
        let indexPath = IndexPath(row: row, section: 0)
        // Insert the row using an animation that inserts the cell from the top.
        self.tableView.insertRows(at: [indexPath], with: .top)
      }
    usersRefObservers.append(childAdded)
    
    let childRemoved = usersRef
      .observe(.childRemoved) {[weak self] snap in
        guard
          let emailToFind = snap.value as? String,
          let self = self
        else { return }

        for (index, email) in self.currentUsers.enumerated()
        where email == emailToFind {
          let indexPath = IndexPath(row: index, section: 0)
          self.currentUsers.remove(at: index)
          self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
      }
    usersRefObservers.append(childRemoved)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    /// This removes relevant observers from usersRef.
    usersRefObservers.forEach(usersRef.removeObserver(withHandle:))
    usersRefObservers = []
  }

  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }

  // MARK: Actions
  @IBAction func signOutDidTouch(_ sender: AnyObject) {
    // First, you get the currentUser and create onlineRef using its uid, a unique identifier representing the user.
    guard let user = Auth.auth().currentUser else { return }
    let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
    // You call removeValue to delete the value for onlineRef. While Firebase automatically adds the user to online upon sign in, it doesn’t remove the user on sign out. Instead, it only removes users when they become disconnected.
    // For this app, it doesn’t make sense to show users as online after they log out. So, you manually remove them here.
    onlineRef.removeValue { error, _ in
      // Within the completion closure, you first check if there’s an error and simply print it if so.
      if let error = error {
        print("Removing online failed: \(error)")
        return
      }
      // Then you call Auth.auth().signOut() to remove the user’s credentials from the keychain. If there isn’t an error, you dismiss the view controller. Otherwise, you print out the error.
      do {
        try Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
      } catch let error {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}
