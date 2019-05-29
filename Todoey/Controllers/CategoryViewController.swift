//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/18.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    //using core data
//    var categories = [Category]()
    //using realm
    var categories: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //set the text label of the cell object to the name attribute of the category entity
        //using core data
//        cell.textLabel?.text = categories[indexPath.row].name
        //using realm
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"     //Nil Coalescing Operator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //using core data
//        return categories.count
        //using realm
        return categories?.count ?? 1   //Nil Coalescing Operator
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform our segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //get the destination view controller
        let destinationVC = segue.destination as! TodoListViewController
        
        //now we need to get the category that corresponds to the selected cell
        //we need to get the indexPath to do this, we do it like this
        //we tap into the indexPathForSelectedRow property of the tableView object.
        //this is an optional so lets use some optional binding to see if it is set (should always be set)
        if let indexPath = tableView.indexPathForSelectedRow {
            //now if a valid category has been selected (which it should be), send the current category to the destination VC
            //using core data
//            destinationVC.selectedCategory = categories[indexPath.row]
            //using realm
            destinationVC.selectedCategory = categories?[indexPath.row]
            //this is fine because the selectedCategory property of the destinationVC is an optional
        }
    }
    
    //MARK: - Data Manipulation Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //add new categories
        //create our text field
        var textField = UITextField()
        
        //create our alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //create the action for our alert
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //using core data
//            let newCategory = Category(context: self.context)
            //using realm
            let newCategory = Category()
            //set the name attribute to what is provided in the text field
            newCategory.name = textField.text!
            //append the new NSManagedObject to our category array
            //using core data
//            self.categories.append(newCategory)
            //appending doesn't happen in realm because categories is now a Results instead of an Array
            //call our save method using CoreData
//            self.saveCategories()
            //call our save method using realm
            self.save(category: newCategory)
        }
        
        //add a text field to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        //add our action to our alert
        alert.addAction(action)
        
        //present our alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Add New Categories
    //using core data
//    func saveCategories() {
//        do {
//            try context.save()
//        }
//        catch {
//            print("Error During Save, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    //using realm
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error During Save, \(error)")
        }
        
        tableView.reloadData()
    }

    //using core data
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        //with is our external parameter and request is our internal parameter
//        //with can be used anywhere outside this method when calling it, request can only be used in this method
//        //Category.fetchRequest() will be the default value of the internal parameter if no parameter is passed to it when called
//        do {
//            categoryArray = try context.fetch(request)
//        }
//        catch {
//            print("Error During Fetch, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    //using realm
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
