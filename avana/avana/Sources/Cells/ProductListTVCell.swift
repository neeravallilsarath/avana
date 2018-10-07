//
//  ProductListTVCell.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListTVCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingsView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateProductListCell(product: Product) {
        nameLabel.text = product.name
        descriptionLabel.text = product.productDescription
        ratingsLabel.text = "\(product.rating)"
        amountLabel.text = "\(product.price)"
        if let imageURL = product.imageUrl {
            productImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
}
