//
//  Product.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import Foundation
import Firebase

class Product {
    var id: String
    var name: String
    var price: String
    var reviews: Int
    var rating: Int
    var productDescription: String
    var imageUrl: String?
    var fbData : [String : AnyObject]?
    
    init(id: String, document: [String: Any]) {
        self.id = id
        self.name = document["name"] as! String
        self.price = document["price"] as! String
        self.productDescription = document["desc"] as! String
        self.imageUrl = document["imageUrl"] as? String
        self.reviews = document["reviews"] as! Int
        self.rating = document["rating"] as! Int
        self.fbData = [:]
    }
}

extension Product: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Product: CustomStringConvertible {
    var description: String { return "\nid: \(id) \(name): price: \(price), reviews: \(reviews), rating: \(rating)"}

}
