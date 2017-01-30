//
//  Defaults.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/30/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON



let vc = ViewController()




class DefaultCompanies: NSObject {
    
    
    
    
    func setDefaults() {
        let userDefaults = UserDefaults.standard
        let defaultValues = ["firstRun" : true]
        userDefaults.register(defaults: defaultValues)
        
        if userDefaults.bool(forKey: "firstRun") {
            let defaultProducts = ["Apple" : ["iPhone", "iPad", "Macbook"],
                                   "Google" : ["Google", "Firebase", "Magic Leap"],
                                   "Facebook" : ["Facebook", "Instagram", "WhatsApp"],
                                   "Tesla" : ["Model S", "Model X", "Powerwall"],
                                   "Twitter" : ["Twitter", "Periscope", "Vine"]]
            
            let urlDictionary = ["iPhone" : "http://www.apple.com/iphone/",
                                 "iPad" : "http://www.apple.com/ipad/",
                                 "Macbook" : "http://www.apple.com/macbook/",
                                 "Google" : "https://www.google.com/",
                                 "Firebase" : "https://firebase.google.com/",
                                 "Magic Leap" : "https://www.magicleap.com/",
                                 "Facebook" : "https://www.facebook.com/",
                                 "Instagram" : "https://www.instagram.com/?hl=en",
                                 "WhatsApp" : "https://www.whatsapp.com/",
                                 "Model S" : "https://www.tesla.com/models",
                                 "Model X" : "https://www.tesla.com/modelx",
                                 "Powerwall" : "https://www.tesla.com/powerwall",
                                 "Twitter" : "https://twitter.com/?lang=en",
                                 "Periscope" : "https://www.periscope.tv/",
                                 "Vine" : "https://vine.co/"]
            
            let companyEntity = NSEntityDescription.entity(forEntityName: "Company", in: managedContext)!
            let productEntity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
            
            // Setting the default company data (name, logo, and stockPrice)
            let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20Ask%2C%20YearHigh%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22%2C%22GOOG%22%2C%22TWTR%22%2C%22TSLA%22%2C%20%22FB%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let json = JSON(data: data!)
                    if let quotes = json["query"]["results"]["quote"].array {
                        for quote in quotes {
                            let symbol = quote["symbol"].stringValue
                            let name = NSLocalizedString(symbol, comment:"")
                            let ask = quote["Ask"].stringValue
                            let company = NSManagedObject(entity: companyEntity,insertInto: managedContext)
                            company.setValue(name, forKey: "name")
                            company.setValue(name, forKey: "logo")
                            company.setValue(ask, forKey: "stockPrice")
                            companies.append(company)
                            
                            let companyProducts = defaultProducts[name]
                            
                            for productName in companyProducts! {
                                
                                let product = NSManagedObject(entity: productEntity, insertInto:managedContext)
                                let names = urlDictionary[productName]
                                
                                product.setValue(productName, forKey: "name")
                                product.setValue(productName, forKey: "image")
                                product.setValue(names, forKey: "url")
                                
                                product.setValue(company, forKey: "company")
                                
                            }
                            print(json)
                        }
                        
                        DispatchQueue.main.async {
                            do {
                                try managedContext.save()
                                vc.tableView.reloadData()
                                userDefaults.set(false, forKey: "firstRun")
                            } catch let error as NSError {
                                print("Could not save. \(error), \(error.userInfo)")
                            }
                        }
                    }
                } else {
                    print("The data couldn't be loaded")
                }
            }
            task.resume()
        }
    }
    
    
    
    
}
