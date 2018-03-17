//
//  ViewController.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/14/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey:"TodoListArray") as? [Item] {
        itemArray = items

    }
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
    }

    //Mark: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
//        cell.textLabel?.text = itemArray[indexPath.row] //this is actually the beginning for finding stuff. beginning of indexpath. this is later deleted becuase it returns an tiem object when we need the title.
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none //if item.done is true, set cell.accessoryType is set to .checkmark. Same as below.
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }

    //Mark: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//
//        else{
//         tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //same thing as below
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //Mark: Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //what will happen once user clicks Add Item on our alert
//            self.itemArray.append(textField.text!) //added to array, but does not show up without reloading. later changed to append the newItem
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //save the array to defaults. but saving it does not mean that it will show up. It still has to be retrieved from defaults.
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
            print(alertTextField.text) //note, you type in through here, but pressing the add item button triggers Add item action. Thus, you need a local variable textField to store the text.
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}

