//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
  
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    @IBOutlet weak var itemsSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        itemsSearchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? ""
            newItem.done  = false
            self.itemArray.append(newItem)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create your new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
}
    
//MARK: -  TableViewController DataSource and delegates Methods

extension TodoListViewController{
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
        
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: Constants.toDoCellName, for: indexPath)
           let item = itemArray[indexPath.row]
           cell.textLabel?.text = item.title
           cell.accessoryType = (item.done == true) ? .checkmark : .none
           return cell
          }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
                 saveItems()
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

//MARK: -  UISearchBarDelegate  Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate =  NSPredicate(format: "title CONTAINS[cd] %@", itemsSearchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if itemsSearchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                self.itemsSearchBar.resignFirstResponder()
            }
           
        }
    }
}

//MARK: -   CoreData Methods

extension TodoListViewController {
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        do {
       itemArray = try context.fetch(request)
          }
        catch {
            print("Error in fetching items \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func saveItems() {
        
            do {
               try context.save()
            } catch {
                print("Error in saving item\(error)")
        }
        self.tableView.reloadData()
    }
    

}
