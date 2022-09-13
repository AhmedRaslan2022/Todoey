//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }


    
//MARK: -    Add NewItems
    
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            let newItem = item()
            
            newItem.title = textField.text ?? ""
            
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
    
    //MARK: -    Add NewItems
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
            do {
                let data =  try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error in Encoding item array,\(error)")
            }
        self.tableView.reloadData()
    }
    
}
    
    extension TodoListViewController{
    //MARK: -     Load Items
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!){ 
            let decoder = PropertyListDecoder()
            do {
              itemArray = try decoder.decode([item].self, from: data)
            } catch {
                print("Error in Encoding item array,\(error)")
            }
        }
       
    }

}


extension TodoListViewController{
    
    //MARK: -  TableViewController DataSource Methods
        
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
        
        //MARK: -  TableViewController Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
                 saveItems()
            tableView.deselectRow(at: indexPath, animated: true)
        }
}
