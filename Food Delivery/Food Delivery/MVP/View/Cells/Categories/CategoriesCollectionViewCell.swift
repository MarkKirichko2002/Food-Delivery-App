//
//  CategoriesCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoriesCollectionViewCell"
    
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var CategoryName: UILabel!
    
    func configure(categories: FoodCategory) {
        CategoryImage.image = UIImage(named: categories.icon)
        CategoryName.text = categories.name
    }
}
