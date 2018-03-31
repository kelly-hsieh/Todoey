//
//  ViewController.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/14/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//


import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{       ///didSet is a method that gets triggered as soon as the selectedCategory is set, and no longer an optional
        loadItems()
            
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //created a path to the plist, but not the plist itself yet with this code
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //note here that we don't have direct access to AppDelegate or its methods, since AppDelegate is a class. We can only call on its objects. Thus, we use a Appdelegate singleton downcasted into AppDelegate, and then thus giving us access to Appdelegate, and its .persistentcontainer.viewcontext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        print(dataFilePath) //.first since it is a string in order to find the path
        
        // Do any additional setup after loading the view, typically from a nib.
        //        if let items = defaults.array(forKey:"TodoListArray") as? [Item] {
        //        itemArray = items
        //
        //    }
//
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row) //note if these two lines for deletion changed their order, the app will crash since you deleted the item in the array first. Remember to first delete from the context.
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //same thing as below
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //Mark: Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //what will happen once user clicks Add Item on our alert
            //            self.itemArray.append(textField.text!) //added to array, but does not show up without reloading. later changed to append the newItem
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray") //save the array to defaults. but saving it does not mean that it will show up. It still has to be retrieved from defaults.
            //Line crashed later on becayse it uses user default
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
            print(alertTextField.text!) //note, you type in through here, but pressing the add item button triggers Add item action. Thus, you need a local variable textField to store the text.
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark : Model Manipulation Methods
    
    func saveItems() {
        
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //with is an internal name and request is external, to make coding legible.
        //Item.fetchrequest as default value when there isn't a value for the request. Aka, before you actually queried a result, evrything on the list will show up
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest() //request must be initilized by specifically saying that it is of the type NSFetchRequest.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    
}
//Mark: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate { //useful extensions to unclutter TodoListViewController
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest() //submit a request everytime you want to read from database
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //Use NSpredicate to query from database. whatever is on the search bar will be passed into the query part (CONTAINS %@). NS requests are case and diacrtic senstive by default, thus, we added [cd] to make it insensitive.
        
        request.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)] //sort the result of query
        
//        request.sortDescriptors =  [sortDescriptor] //expects an array of sort rule. but here we only need it to contain one sort descriptor
        
        loadItems(with: request, predicate: predicate)
        
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
