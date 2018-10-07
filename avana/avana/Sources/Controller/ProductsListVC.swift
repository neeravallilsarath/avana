//
//  ProductsListVC.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit

class ProductsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var products = Set<Product>()
    var facebookDataDictionary : [String : AnyObject]? = nil
    
    //MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductListTVCell", bundle: nil), forCellReuseIdentifier: "ProductListTVCell")
        tableView.tableFooterView = UIView()
        self.title = "Products"
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Custom Methods -
    
    func fetchProducts() {
        if ConnectionManager.isConnectedToNetwork() {
            activityIndicatorView.startAnimating()
            DataManager.shared.getProducts { (success, products) in
                if let products = products {
                    self.products = self.products.union(products)
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
        else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- TableView DataSource Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVCell") as! ProductListTVCell
        let productsList = Array(products)
        cell.populateProductListCell(product: productsList[indexPath.row])
        return cell
    }
    
    //MARK:- TableView Delegate Methods -

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productsList = Array(products)
        let selectedProduct = productsList[indexPath.row]
        if let fbDict = facebookDataDictionary {
            selectedProduct.fbData = fbDict
        }
        ViewManager.shared.showProductDetail(product: selectedProduct, on: self.navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == products.count - 1 {
            fetchProducts()
        }
    }

}

