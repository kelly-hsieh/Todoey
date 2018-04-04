//
//  ViewController.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/14/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{       ///didSet is a method that gets triggered as soon as the selectedCategory is set, and no longer an optional
        loadItems()
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none

    }
    
    //Mark: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)

        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        }
        return cell

    }
    
    //Mark: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            
            do{
                try realm.write {
                item.done = !item.done
                //realm.delete(item) delete stuff on realm
            }
            } catch {
                print("Error saving done status, \(error)")
            }
            tableView.reloadData()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    }
        
    
    
    //Mark: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
            
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
            }
    
    
    //Mark : Model Manipulation Methods
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
    
    //Mark: Delete data from swipe
   
    override func updateModel(at indexPath: IndexPath) {
       
        if let deletedItem = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deletedItem)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
        }
    }
}



    
//Mark: Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { //when text changed but also is zero. aka you deleted your query
            loadItems()
            DispatchQueue.main.async { //DispatchQueue to use the main Queque and dismiss the search bar etc. this is because you would want to dismiss it while the background queues are still running.

                searchBar.resignFirstResponder() //this used to stop searchbar and keyboard on foreground
            }

        }

    }

}



