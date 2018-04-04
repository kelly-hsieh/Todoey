//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/25/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
        tableView.separatorStyle = .none
        
    }
    
    //Mark : Tableview Datasource Methods - read
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //if categories is nil, return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //allows us to tap into cell from swipetableview
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added" //anticipated nil. So if category is nil, return "No Categories Added"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "C3ABB2")

        
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
    
    //Mark: Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deletedCat = self.categories?[indexPath.row] {
                            do {
                                try self.realm.write {
                                    self.realm.delete(deletedCat)
                                }
                            } catch {
                                print("Error deleting category, \(error)")
                            }
        
                        }
    }
    
    
    // Mark: Add New Categories - when IB Action is pressed

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            
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





