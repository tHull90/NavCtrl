//
//  CompanyController.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import CoreData

var products = [NSManagedObject]()
var companies = [NSManagedObject]()
var container: NSPersistentContainer!
let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let companyEntity = "Company"
let productEntity = "Product"

// Bool so Edit button allows double tap (once to show edit stuff then again to hide)
var doubleTap : Bool = false




class CompanyController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var productController: ProductController?
    let cellId = "Cell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navbar stuff
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        title = "Companies"
        
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Company")
        
        //3
        do {
            companies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
    
    
    
    
    // *MARK* Add/Edit/Delete
    
    func handleAdd() {
        
        let alert = UIAlertController(title: "New Company", message: "Add a new company", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let newCompany = textField.text else {
                    return
            }
            self.save(name: newCompany)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func handleEdit() {
        
        if (doubleTap) {
            //Second Tap
            doubleTap = false
            self.setEditing(false, animated: true)
        } else {
            //First Tap
            doubleTap = true
            self.setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        let company = companies[indexPath.row]
        
        if editingStyle == .delete {
            managedContext.delete(company)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            
        }
        
        // Fetch new data/reload table
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: companyEntity)
        
        do {
            companies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Company",
                                       in: managedContext)!
        let company = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        company.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            companies.append(company)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // *MARK* Tableview data sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Cell
        let company = companies[indexPath.row]
        let stock = company.value(forKey: "stockPrice") as? String
        
        // Company name labels
        cell.textLabel?.text = company.value(forKey: "name") as? String
        
        // Stock price underneath
        if let stock = stock {
            cell.detailTextLabel?.text = "Current stock price: \(stock)"
        }
        
        // Logos
        DispatchQueue.main.async {
            if let logo = company.value(forKey: "logo") as? String {
                cell.logoView.image = UIImage(named: logo)
            } else {
                cell.logoView.image = UIImage(named: "noImage")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = companies[indexPath.row]
        
        let nc = UINavigationController()
        let productController = ProductController()
        nc.viewControllers = [productController]
        productController.navigationItem.title = company.value(forKey: "name") as? String
        
        present(nc, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
