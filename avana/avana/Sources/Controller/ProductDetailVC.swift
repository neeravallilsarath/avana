//
//  ProductDetailVC.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var buyNowButton: UIButton!
    
    var product : Product? = nil
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Custom Methods -
    
    func setupUI() {
        self.title = "Details"
        buyNowButton.layer.cornerRadius = buyNowButton.frame.size.height / 2
        nameLabel.text = product?.name
        descriptionLabel.text = product?.productDescription
        ratingsLabel.text = "\(product?.rating ?? 1)"
        amountLabel.text = product?.price
        if let reviews = product?.reviews {
            reviewsLabel.text = "\(reviews) reviews"
        }
        if let imageURL = product?.imageUrl {
            productImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    //MARK:- Action Methods -

    @IBAction func buyNowAction(_ sender: Any) {
        ViewManager.shared.showDeliveyInformation(product: product, on: self.navigationController)
    }
    
}
