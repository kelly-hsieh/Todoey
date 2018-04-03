//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/25/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()
    }
    
    //Mark : Tableview Datasource Methods - read
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //if categories is nil, return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added" //anticipated nil. So if category is nil, return "No Categories Added"
        
        return cell
        
    }
    
    //Mark: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self) //perform segueway when the categoryCell is selected
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //we need to prepare the Items inside the Items class for the segueway, otherwise currently when the segueway is pressed, the entire todo list will be loaded up, and not just the items relevant to that specfic category selected.
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {// FYI indexpathforselectedrow is an optional.
            
            destinationVC.selectedCategory = categories?[indexPath.row] //we then create the selctedCategory method under TodoListViewController
        
    }
    }
    
    
    
    
    
    //Mark : Data Manipulation Methods - save and load

    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // Mark: Add New Categories - when IB Action is pressed

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
   
            self.save(category: newCategory)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    
    
    
    
    
    
}
