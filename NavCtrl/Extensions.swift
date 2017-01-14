//
//  Extensions.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController
{
    
    
    // Showing & hiding keyboard will adjust views
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    
    
    
}






//Check for internet
//    override func viewDidAppear(_ animated: Bool) {
//        if Reachability.isConnectedToNetwork() == true {
//            print("Internet connection OK")
//        } else {
//            print("Internet connection FAILED")
//            var networkAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
//            networkAlert.show()
//            }
//    }


//        // "Companies" title is a button that allows user to add their own companies
//        let button =  UIButton(type: .custom)
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        button.backgroundColor = UIColor.clear
//        button.setTitle("Companies", for: UIControlState.normal)
//        button.addTarget(self, action: #selector(showAddCompanyTextField), for: UIControlEvents.touchUpInside)
//        self.navigationItem.titleView = button
//        button.setTitleColor(UIColor.black, for: .normal)



// Clear user defaults
//        if let bundle = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundle)
//        }
