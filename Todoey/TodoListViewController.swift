//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/08.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Take Merlin to the vet", "Take Jasmine to the beach", "Chill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //this will remove the checkmark from our cells
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            //this will add a checkmark to our table cells
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        
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
            self.itemArray.append(textField.text!)
            
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

