//
//  CompanyController.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import ReachabilitySwift
import SystemConfiguration



// Bool so Edit button allows double tap (once to show edit stuff then again to hide)
var doubleTap : Bool = false




class CompanyController: UITableViewController {
    
    let cellId = "Cell"
    var productController: ProductController?
    var stockPrices = [String]()
    //    var companies: [Company]!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        
        self.navigationItem.title = "Companies"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(showAddCompanyTextField))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //        companies = companyList()
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    // *MARK* Table view data sources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Cell
        
        // Labels
        cell.textLabel?.text = companyNames[indexPath.row]
        
        
        // Detail labels
        stockFetcher(completion: {
            (prices) -> Void in
            
            if (prices?.count)! > indexPath.row + 1 {
                cell.detailTextLabel?.text = "Current Stock Price: \(prices![indexPath.row])"
            } else {
                cell.detailTextLabel?.text = "No data found"
            }
            
        })
        
        
        // Company Logos
        DispatchQueue.main.async {
            if (logos.count) >= indexPath.row + 1 {
                cell.logoView.image = UIImage(named: logos[indexPath.row])
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
        let nc = UINavigationController()
        let productController = ProductController()
        nc.viewControllers = [productController]
        productController.navigationItem.title = companyNames[indexPath.row]
        

                let pageTitle = productController.navigationItem.title
        
                switch pageTitle! {
                case "Apple":
                    products = appleProducts
                    productImages = appleImages
                case "Google":
                    products = googleProducts
                    productImages = googleImages
                case "Twitter":
                    products = twitterProducts
                    productImages = twitterImages
                case "Tesla":
                    products = teslaProducts
                    productImages = teslaImages
                case "Samsung":
                    products = samsungProducts
                    productImages = samsungImages
                default:
                    products = newProducts
                    productImages = newProductImages
                }

        
        
        present(nc, animated: true, completion: nil)
    }
    
    
    
    
    // *MARK* Delete & Edit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            tableView.beginUpdates()
            companyNames.remove(at: indexPath.row)
            logos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = companyNames[sourceIndexPath.row]
        companyNames.remove(at: sourceIndexPath.row)
        companyNames.insert(item, at: destinationIndexPath.row)
        logos.remove(at: sourceIndexPath.row)
        logos.insert(item, at: destinationIndexPath.row)
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
    
    
    
    
    
    
    // *MARK* Adding companies
    lazy var addCompanyTextField: UITextField = {
        let textField = UITextField(frame:CGRect(origin:.zero, size:CGSize(width:100, height:28)))
        textField.borderStyle = .none
        self.navigationItem.titleView = textField
        textField.placeholder = "Add a new company..."
        
        
        return textField
    }()
    
    
    // Clear text field & return page to normal once done button is pressed
    func clearAddtextField() {
        self.addCompanyTextField.text = nil
        self.navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        tableView.reloadData()
    }
    
    func showAddCompanyTextField() {
        self.navigationItem.titleView = addCompanyTextField
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleAdd))
    }
    
    func handleAdd() {
        
        // append companies array with newCompany
        let newCompany = addCompanyTextField.text!
        
        if addCompanyTextField.text != "" {
            companyNames.append("\(newCompany)")
            clearAddtextField()
        } else {
            clearAddtextField()
        }
        
    }
    
    
    
    
    
    
    
    
}
