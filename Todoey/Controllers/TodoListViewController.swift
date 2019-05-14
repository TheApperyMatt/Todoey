//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/08.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
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
    
    func saveItems() {
        //save the newly updated itemArray to our default database
        //create new encoder object
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error During Encoding, \(error)")
        }
        
        //reload the data of the table view
        tableView.reloadData()
    }
    
    func loadItems() {
        //let's get our data
        if let data = try? Data(contentsOf: dataFilePath!) {
            //create our decoder object
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error During Decoding, \(error)")
            }
        }
    }
}

