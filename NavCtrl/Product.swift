//
//  Product.swift
//  NavCtrl
//
//  Created by Timothy Hull on 1/14/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit


var productController: ProductController?


var products = [String]()
var appleProducts = ["iPad", "iPod", "iPhone"]
var googleProducts = ["Search", "Firebase", "Pixel"]
var twitterProducts = ["Twitter", "Periscope", "Vine"]
var teslaProducts = ["Tesla Model S", "Tesla Model X", "Tesla Powerwall"]
var samsungProducts = ["Samsung Galaxy", "Samsung Note", "Samsung Tab"]
var newProducts = [String]()

var productImages = [String]()
var appleImages = ["iPad", "iPod", "iPhone"]
var googleImages = ["GoogleLogo", "Firebase", "Pixel"]
var twitterImages = ["TwitterLogo", "Periscope", "Vine"]
var teslaImages = ["TeslaS", "TeslaX", "TeslaPowerwall"]
var samsungImages = ["SamsungGalaxy", "SamsungNote", "SamsungTab"]
//var newProductImages = ["noImage", "noImage", "noImage"]
var newProductImages = [String]()

var productUrls = [NSURL]()
var appleUrls = [NSURL(string: "http://www.apple.com/iphone/"), NSURL(string: "http://www.apple.com/ipod/"), NSURL(string: "http://www.apple.com/iphone/")]
var googleUrls = [NSURL(string: "https://www.google.com/"), NSURL(string: "https://firebase.google.com/"), NSURL(string: "https://madeby.google.com/phone/")]
var twitterUrls = [NSURL(string: "https://twitter.com/?lang=en"), NSURL(string: "https://vine.co/"), NSURL(string: "https://www.periscope.tv/")]
var teslaUrls = [NSURL(string: "https://www.tesla.com/models"), NSURL(string: "https://www.tesla.com/modelx"), NSURL(string: "https://www.tesla.com/powerwall")]
var samsungUrls = [NSURL(string: "http://www.samsung.com/global/galaxy/"), NSURL(string: "http://www.samsung.com/us/mobile/phones/galaxy-note/s/_/n-10+11+hv1rp+zq1xb"), NSURL(string: "http://www.samsung.com/us/mobile/tablets/galaxy-tab-s2/s/_/n-10+11+hv1rq+zq1xl/")]





class Product: NSObject {
    
    var productName: String?
    var productImage: String?
    var productUrl: NSURL?
    
}
