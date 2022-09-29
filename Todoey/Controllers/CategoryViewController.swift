//
//  TableViewController.swift
//  Todoey
//
//  Created by Macintosh on 27/09/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
 
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert  = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text ?? ""
            self.categoriesArray.append(newCategory)
            self.saveCategories()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Your new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
 
}

//MARK: -   CoreData Methods

extension CategoryViewController {
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
       categoriesArray = try context.fetch(request)
          }
        catch {
            print("Error in fetching Categorys \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func saveCategories() {
        
            do {
               try context.save()
            } catch {
                print("Error in saving Category \(error)")
        }
        self.tableView.reloadData()
    }
    

}

 // MARK: -  TableViewController DataSource and delegates Methods

extension CategoryViewController{

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoriesArray.count
        }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell, for: indexPath)
           let category = categoriesArray[indexPath.row]
           cell.textLabel?.text = category.name
//           cell.accessoryType = (item.done == true) ? .checkmark : .none
           return cell
          }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.categoryToItems, sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
        
    }

}
