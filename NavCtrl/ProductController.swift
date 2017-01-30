//
//  ProductController.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import WebKit



class ProductController: UITableViewController, WKNavigationDelegate {
    
    let cellId = "Cell"
    var webView: WKWebView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        
        webView = WKWebView()
        
        setPage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    // *MARK* Tableview data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Cell
        
        cell.textLabel?.text = products[indexPath.row]
        
        DispatchQueue.main.async {
            if (productImages.count) >= indexPath.row + 1 {
                cell.logoView.image = UIImage(named: productImages[indexPath.row])
            } else {
                cell.logoView.image = UIImage(named: "noImage")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    
    
    
    
    // *MARK* Delete, Edit & Back
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            tableView.beginUpdates()
            products.remove(at: indexPath.row)
            productImages.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func handleBackButton() {
        
        let cc = UINavigationController()
        let companyController = CompanyController()
        cc.viewControllers = [companyController]
        companyController.productController = self
        present(cc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = products[sourceIndexPath.row]
        products.remove(at: sourceIndexPath.row)
        products.insert(item, at: destinationIndexPath.row)
    }
    
    func handleEdit() {
        
        if (doubleTap) {
            //Second Tap
            doubleTap = false
            self.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        } else {
            //First Tap
            doubleTap = true
            self.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Products", style: .plain, target: self, action: #selector(showAddProductTextField))
        }
    }
    
    
    
    
    
    // Set page
    func setPage() {
        let pageTitle = self.navigationItem.title
        
        switch pageTitle! {
        case "Apple":
            productUrls = appleUrls as! [NSURL]
            products = appleProducts
            productImages = appleImages
        case "Google":
            productUrls = googleUrls as! [NSURL]
            products = googleProducts
            productImages = googleImages
        case "Twitter":
            productUrls = twitterUrls as! [NSURL]
            products = twitterProducts
            productImages = twitterImages
        case "Tesla":
            productUrls = teslaUrls as! [NSURL]
            products = teslaProducts
            productImages = teslaImages
        case "Samsung":
            productUrls = samsungUrls as! [NSURL]
            products = samsungProducts
            productImages = samsungImages
        default:
            products = newProducts
            productImages = newProductImages
        }
        
        tableView.reloadData()
    }
    
    
    
    
    // WebView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        webView.load(URLRequest(url: productUrls[indexPath.row] as URL))
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    
    
    
    
    
    // *MARK* Adding companies
    lazy var addProductTextField: UITextField = {
        let textField = UITextField(frame:CGRect(origin:.zero, size:CGSize(width:100, height:28)))
        textField.borderStyle = .none
        self.navigationItem.titleView = textField
        textField.placeholder = "Add some products..."
        
        return textField
    }()
    
    func showAddProductTextField() {
        self.navigationItem.titleView = addProductTextField
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleAddProduct))
        
    }
    
    // Clear text field & return page to normal once done button is pressed
    func clearAddtextField() {
        self.setEditing(false, animated: true)
        self.addProductTextField.text = nil
        self.navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        tableView.reloadData()
    }
    
    func handleAddProduct() {
        let newProduct = addProductTextField.text!
        
        // append newProducts array with newProduct
        if self.addProductTextField.text != "" {
            
            switch self.navigationItem.title! {
            case "Apple":
                appleProducts.append("\(newProduct)")
            case "Google":
                googleProducts.append("\(newProduct)")
            case "Twitter":
                twitterProducts.append("\(newProduct)")
            case "Tesla":
                teslaProducts.append("\(newProduct)")
            case "Samsung":
                samsungProducts.append("\(newProduct)")
            default:
                newProducts.append("\(newProduct)")
            }
            clearAddtextField()
            setPage()
        } else {
            clearAddtextField()
        }
        
    }
    
    
    
    
    
}
