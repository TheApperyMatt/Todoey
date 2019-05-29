//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/08.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import UIKit
//using core data
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    //using core data
//    var listItems = [Item]()
    
    //using realm
    var listItems: Results<Item>?
    
    //create our selectedCategory variable
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //using core data
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        //instead of typing out the itemArray[indexPath.row] all the time, assign it to a shorter constant
        //using core data
//        let item = listItems[indexPath.row]
//
//        cell.textLabel?.text = item.title
//
//        //let's fix the above code using the ternary operator
//        //value = condition ? valueIfTrue : valueIfFalse
//        cell.accessoryType = item.done ? .checkmark : .none
        
        //using realm
        if let item = listItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //let's fix the above code using the ternary operator
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //using core data
//        return listItems.count
        //using realm
        return listItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check if the done property of this instance of the Item class is set
        //set it to true if it is false and false if it is true
        //using core data
//        listItems[indexPath.row].done = !itemArray[indexPath.row].done
        
        //delete a row when it is tapped
        //remember that order is important, you can't delete from the context when indexPath.row doesn't exist
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        saveItems()
        
        //using realm
        if let item = listItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error During Update, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //this changes the row from staying highlighted in grey, to highlighting for a while and then going back to normal
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    //using core data
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//        //create our textfield here
//        var textField = UITextField()
//
//        //create our alert
//        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
//
//        //now create our action
//        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            //this will happen when the user taps the "Add Item" button
//            //using the Codable protocol
////            let newItem = Item()
//
//            //using Core Data
//            let newItem = Item(context: self.context)
//
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
////            print("Item Array, \(self.itemArray)")
//            self.saveItems()
//        }
    //add a textfield to our alert
//    alert.addTextField { (alertTextField) in
//    alertTextField.placeholder = "Create New Item"
//    textField = alertTextField
//    }
//    
//    //now add our action to our alert
//    alert.addAction(action)
//    
//    //present our alert
//    present(alert, animated: true, completion: nil)
//}
    
    //using realm
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create our textfield here
        var textField = UITextField()
        
        //create our alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //get the current date
        let date = Date()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: date)
        
        //now create our action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this will happen when the user taps the "Add Item" button
            //using the Codable protocol
            //            let newItem = Item()
            
            //check if the selectedCategory is set, assign it to currentCategory if it is
            if let currentCategory = self.selectedCategory {
                do {
                    //try write to our realm
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = currentDate
                        //this is where the actual write to the realm is taking place
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error Saving Item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        //add a textfield to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        //now add our action to our alert
        alert.addAction(action)
        
        //present our alert
        present(alert, animated: true, completion: nil)
    }

//    this is for the Codable protocol
//    func saveItems() {
//        //save the newly updated itemArray to our default database
//        //create new encoder object
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        }
//        catch {
//            print("Error During Encoding, \(error)")
//        }
//
//        //reload the data of the table view
//        tableView.reloadData()
//    }
    
    //using core data
//    func saveItems() {
//        do {
//            try context.save()
//        }
//        catch {
//            print("Error Saving Context, \(error)")
//        }
//
//        //always remember this!
//        self.tableView.reloadData()
//    }
    
//this is for the Codable protocol
//    func loadItems() {
//        //let's get our data
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            //create our decoder object
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch {
//                print("Error During Decoding, \(error)")
//            }
//        }
//    }

    //using core data
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        //create our category predicate
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        //use optional binding to check if a predicate parameter has been passed to this method or not
//        if let additionalPredicate = predicate {
//            //this means a predicate has been passed so we need to create a compound predicate to add to the request
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else {
//            //this means no additional parameter has been passed so we just add the category predicate to the request
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        }
//        catch {
//            print("Error During Fetch, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    //using realm
    func loadItems() {
        listItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate Extension

//using core data
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //create request object
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //add predicate to request
////        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //create our predicate object now that our loadItems method has changed and can accept a predicate parameter
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //add sort descriptors to request
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        //load items with modified request (query database)
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //check that the search bar has been cleared
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            //deselect search bar and dismiss the keyboard on the main thread
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

//using realm
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //query realm
        listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //check that the search bar has been cleared
        if searchBar.text?.count == 0 {
            loadItems()
            
            //deselect search bar and dismiss the keyboard on the main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

