//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/08.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //create our selectedCategory variable
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //let's fix the above code using the ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check if the done property of this instance of the Item class is set
        //set it to true if it is false and false if it is true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //delete a row when it is tapped
        //remember that order is important, you can't delete from the context when indexPath.row doesn't exist
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        //this changes the row from staying highlighted in grey, to highlighting for a while and then going back to normal
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create our textfield here
        var textField = UITextField()
        
        //create our alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //now create our action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this will happen when the user taps the "Add Item" button
            //using the Codable protocol
//            let newItem = Item()
            
            //using Core Data
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
//            print("Item Array, \(self.itemArray)")
            self.saveItems()
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
    
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error Saving Context, \(error)")
        }
        
        //always remember this!
        self.tableView.reloadData()
    }
    
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
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //create our category predicate
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //use optional binding to check if a predicate parameter has been passed to this method or not
        if let additionalPredicate = predicate {
            //this means a predicate has been passed so we need to create a compound predicate to add to the request
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            //this means no additional parameter has been passed so we just add the category predicate to the request
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error During Fetch, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate Extension

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //create request object
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //add predicate to request
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //create our predicate object now that our loadItems method has changed and can accept a predicate parameter
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //add sort descriptors to request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //load items with modified request (query database)
        loadItems(with: request, predicate: predicate)
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
