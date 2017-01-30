//
//  ProductController.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class ProductController: UITableViewController, NSFetchedResultsControllerDelegate, WKNavigationDelegate {
    
    
    let cellId = "Cell"
    var viewController: CompanyController?
    var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        
        // Navbar stuff
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        
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
        let companyToDisplay = self.navigationItem.title!
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format:"company.name == %@",companyToDisplay)
        //3
        do {
            products = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Product",
                                       in: managedContext)!
        
        let product = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        product.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            products.append(product)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    
    // *MARK* Tableview data sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Cell
        let product = products[indexPath.row]
        
        cell.textLabel?.text = product.value(forKey: "name") as? String
        
        // Product images
        DispatchQueue.main.async {
            if let image = product.value(forKey: "image") as? String {
                cell.logoView.image = UIImage(named: image)
            } else {
                cell.logoView.image = UIImage(named: "noImage")
            }
        }
        
        return cell
    }
    
    
    
    
    
    // *MARK* Back/Edit/Add/Delete
    
    func handleBackButton() {
        
        let cc = UINavigationController()
        let companyController = CompanyController()
        cc.viewControllers = [companyController]
        companyController.productController = self
        present(cc, animated: true, completion: nil)
    }
    
    //    func handleEdit() {
    //
    //        if (doubleTap) {
    //            //Second Tap
    //            doubleTap = false
    //            self.setEditing(false, animated: true)
    //            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
    //        } else {
    //            //First Tap
    //            doubleTap = true
    //            self.setEditing(true, animated: true)
    //            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Products", style: .plain, target: self, action: #selector(handleAdd))
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        let product = products[indexPath.row]
        
        if editingStyle == .delete {
            managedContext.delete(product)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            
        }
        
        // Fetch new data/reload table
        //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: productEntity)
        //
        //        do {
        //            products = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        //        } catch let error as NSError {
        //            print("Error While Fetching Data From DB: \(error.userInfo)")
        //        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func handleAdd() {
        
        let alert = UIAlertController(title: "New Product", message: "Add a new product", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let newProduct = textField.text else {
                    return
            }
            
            self.save(name: newProduct)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    // WebView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = products[indexPath.row]
        
        if let urlString = product.value(forKey: "url") as? String {
            let url = URL(string:urlString)
            webView.load(URLRequest(url: url!))
            webView.allowsBackForwardNavigationGestures = true
            view = webView
        }
        
        print(product.value(forKey: "url") as? URL)
        print(product.value(forKey: "url"))
        print(product)
    }
    
    
    
    
    
    
}
