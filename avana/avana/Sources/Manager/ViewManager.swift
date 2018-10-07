//
//  ViewManager.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import Foundation
import UIKit

class ViewManager {
    static let shared = ViewManager()
    
    func showProductList(fbData: Dictionary<String, AnyObject>?, on parent : UIViewController? = nil, modal: Bool = false, animated : Bool = true) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsListVC") as! ProductsListVC
        vc.facebookDataDictionary = fbData
        let nav = UINavigationController(rootViewController: vc)
        showViewController(nav, on: parent, modal: modal, animated: animated)
    }
    
    func showProductDetail(product: Product?, on parent : UIViewController? = nil, modal: Bool = false, animated : Bool = true) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = product
        showViewController(vc, on: parent, modal: modal, animated: animated)
    }
    
    func showDeliveyInformation(product: Product?, on parent : UIViewController? = nil, modal: Bool = false, animated : Bool = true) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeliveryInformationVC") as! DeliveryInformationVC
        vc.product = product
        showViewController(vc, on: parent, modal: modal, animated: animated)
    }
    
    func showCheckoutVC(product: Product?, on parent : UIViewController? = nil, modal: Bool = false, animated : Bool = true) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        vc.product = product
        showViewController(vc, on: parent, modal: modal, animated: animated)
    }
    
    fileprivate func showViewController(_ viewController : UIViewController, on parent : UIViewController? = nil, modal: Bool = false, animated : Bool = true) {
        if modal {
            if let parentVC = parent {
                parentVC.present(viewController, animated: animated)
            }
        } else {
            if let nav = parent as? UINavigationController {
                nav.pushViewController(viewController, animated: animated)
            } else {
                print("Did not pass in a navigation controller to push on")
            }
        }
    }
    
}
