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
    
    //interface to user's default database
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Make some coffee"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Make some eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Do some dishes"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        //instead of typing out the itemArray[indexPath.row] all the time, assign it to a shorter constant
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //check the value of the done property of this instance of the Item class
        //if true make checkmark, if false remove checkmark
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
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
//        print(itemArray[indexPath.row])
        
        //check if the done property of this instance of the Item class is set
        //set it to true if it is false and false if it is true
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
        //instead of using the if else statement above, we can do this
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
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
            
            //save the newly updated itemArray to our default database
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //reload the data of the table view
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
    
    
}

