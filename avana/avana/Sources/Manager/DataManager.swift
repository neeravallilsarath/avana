//
//  DataManager.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DataManager: NSObject {
    static let shared = DataManager()
    let db = Firestore.firestore()
    var lastDocument: QueryDocumentSnapshot?
    
    
    func getProducts(refresh: Bool = false, pageSize: Int = 10, completion: @escaping (_ success: Bool, _ products: [Product]?) -> Void) {
        
        var ref: Query = db.collection("products")
            .limit(to: pageSize)
        
        if refresh {
            lastDocument = nil
        }
        
        if let lastSnapshot = lastDocument {
            ref = db.collection("products")
                .start(afterDocument: lastSnapshot)
                .limit(to: pageSize)
        }
        
        ref.getDocuments { (snapshot, error) in
            var products = [Product]()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    products.append(Product(id: document.documentID, document: document.data()))
                }
                print(products)
                self.lastDocument = snapshot.documents.last
                completion(true, products)
            }
            else {
                completion(false, nil)
            }
        }
    }
    
    func uploadBill(dataString: String) {
        let userId = 1
        let dict = ["userId": userId, "data": dataString] as [String : Any]
        db.collection("bills").addDocument(data: dict) { (error) in
            
        }
    }
    
    //    func testData() {
    //
    //        if let path = Bundle.main.url(forResource: "products", withExtension: "json"),
    //            let data = try? Data(contentsOf: path),
    //            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
    //            let products = json?["products"] as? [[String: Any]] {
    //            for prod in products {
    //                db.collection("products").addDocument(data: prod)
    //            }
    //        }
    //    }
}
