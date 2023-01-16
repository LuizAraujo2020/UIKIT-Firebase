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

class GroceryListTableViewController: UITableViewController {
  // MARK: Constants
  let listToUsers = "ListToUsers"

  // MARK: Properties
  var items: [GroceryItem] = []
  var user: User?
  var onlineUserCount = UIBarButtonItem()
  
  /// Establish a connection to your Firebase database at a given path.
  /// In short, these properties let you save and sync data to the given location.
  let ref = Database.database().reference(withPath: "grocery-items")
  /// Keep track of the references you add, so you can clean them up later.
  var refObservers: [DatabaseHandle] = []

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.allowsMultipleSelectionDuringEditing = false

    onlineUserCount = UIBarButtonItem(
      title: "1",
      style: .plain,
      target: self,
      action: #selector(onlineUserCountDidTouch))
    onlineUserCount.tintColor = .white
    navigationItem.leftBarButtonItem = onlineUserCount
    user = User(uid: "FakeId", email: "hungry@person.food")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    /// The event type specifies what event you want to listen for. The code listens for a .value event type, which reports all types of changes to the data in your Firebase database: added, removed and changed (CRUD).
    /// When the change occurs, the database updates the app with the most recent data.
    // You attach a listener to receive updates whenever the grocery-items endpoint changes. The database triggers the listener block once for the initial data and again whenever the data changes.
    let completed = ref.observe(.value) { snapshot in
      // Then, you store the latest version of the data in a local variable inside the listener’s closure.
      var newItems: [GroceryItem] = []
      // The listener’s closure returns a snapshot of the latest set of data. The snapshot contains the entire list of grocery items, not just the updates. Using children, you loop through the grocery items.
      for child in snapshot.children {
        // GroceryItem has an initializer that populates its properties using a DataSnapshot. A snapshot’s value is of type AnyObject and can be a dictionary, array, number or string. After creating an instance of GroceryItem, you add it to the array that contains the latest version of the data.
        if
          let snapshot = child as? DataSnapshot,
          let groceryItem = GroceryItem(snapshot: snapshot) {
          newItems.append(groceryItem)
        }
      }
      // You replace items with the latest version of the data, then reload the table view so it displays the latest version.
      self.items = newItems
      self.tableView.reloadData()
    }
    // Store a reference to the listener block so you can remove it later.
    refObservers.append(completed)

  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    ///Here, you iterate over all the observers you’ve previously added and remove them from ref.
    refObservers.forEach(ref.removeObserver(withHandle:))
    refObservers = []
  }

  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let groceryItem = items[indexPath.row]

    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = groceryItem.addedByUser

    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)

    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      items.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    var groceryItem = items[indexPath.row]
    let toggledCompletion = !groceryItem.completed

    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    groceryItem.completed = toggledCompletion
    tableView.reloadData()
  }

  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = .gray
      cell.detailTextLabel?.textColor = .gray
    }
  }

  // MARK: Add Item
  @IBAction func addItemDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(
      title: "Grocery Item",
      message: "Add an Item",
      preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      // Get the text field and its text from the alert controller.
      guard
        let textField = alert.textFields?.first,
        let text = textField.text,
        let user = self.user
      else { return }
      
      // Using the current user’s data, you create a new GroceryItem.
      let groceryItem = GroceryItem(
        name: text,
        addedByUser: user.email,
        completed: false)

      // Create a child reference.
      let groceryItemRef = self.ref.child(text.lowercased())

      // Use setValue(_:) to save data to the database. This method expects a Dictionary. GroceryItem has a helper method called toAnyObject() to turn it into a Dictionary.
      groceryItemRef.setValue(groceryItem.toAnyObject())
    }


    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: .cancel)

    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  @objc func onlineUserCountDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}
