//
//  Company.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



var companyController: CompanyController?

let stockUrl = "https://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20Ask%2C%20YearHigh%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22%2C%22GOOG%22%2C%22TWTR%22%2C%22TSLA%22%2C%20%22SSNLF%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

var prices = [String]()
var companyNames = ["Apple", "Google", "Twitter", "Tesla", "Samsung"]
var logos = ["AppleLogo", "GoogleLogo", "TwitterLogo", "TeslaLogo", "SamsungLogo"]

//var companies = [String]()

//let names = companyList().map({ $0.companyName })
//let logo = companyList().map({ $0.companyName })
//let price = companyList().map({ $0.companyName })



class Company: NSObject {
    
    var companyName: String
    var companyLogo: String
    var stockPrice: String
    init(companyName:String, companyLogo:String, stockPrice:String) {
        self.companyName = companyName
        self.companyLogo = companyLogo
        self.stockPrice = stockPrice
    }
}






func stockFetcher(completion: @escaping ([String]?) -> Void) {
    Alamofire.request(stockUrl).responseJSON { (responseData) -> Void in
        if((responseData.result.value) != nil) {
            let json = JSON(responseData.result.value!)
            if let appleStockPrice = json["query"]["results"]["quote"][0]["Ask"].string {
                prices.append(appleStockPrice)
            }
            if let googleStockPrice = json["query"]["results"]["quote"][1]["Ask"].string {
                prices.append(googleStockPrice)
            }
            if let twitterStockPrice = json["query"]["results"]["quote"][2]["Ask"].string {
                prices.append(twitterStockPrice)
            }
            if let teslaStockPrice = json["query"]["results"]["quote"][3]["Ask"].string {
                prices.append(teslaStockPrice)
            }
            if let samsungStockPrice = json["query"]["results"]["quote"][4]["Ask"].string {
                prices.append(samsungStockPrice)
            }
            completion(prices)
            print(json)
        }
    }
}







func companyList() -> [Company] {
    
    let apple = Company(companyName: "Apple", companyLogo: "AppleLogo", stockPrice: prices[0])
    let google = Company(companyName: "Google", companyLogo: "GoogleLogo", stockPrice: prices[1])
    let twitter = Company(companyName: "Twitter", companyLogo: "TwitterLogo", stockPrice: prices[2])
    let tesla = Company(companyName: "Tesla", companyLogo: "TeslaLogo", stockPrice: prices[3])
    let samsung = Company(companyName: "Samsung", companyLogo: "SamsungLogo", stockPrice: prices[4])
    
    
    return [apple, google, twitter, tesla, samsung]
}




//Stocks (long way)
//    func stocks() {
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20Ask%2C%20YearHigh%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
//
//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//
//            if error != nil {
//
//                print(error!.localizedDescription)
//
//            } else {
//
//                do {
//
//                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//                    {
//
//                        //Logic here
//                        print(json)
//
//
//                    }
//
//                } catch {
//
//                    print("error in JSONSerialization")
//
//                }
//
//
//            }
//
//        })
//        task.resume()
//
//    }
