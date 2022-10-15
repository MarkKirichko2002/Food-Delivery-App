//
//  FoodCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import UIKit
import SDWebImage

class FoodCollectionViewCell: UICollectionViewCell {

    static let identifier = "FoodCollectionViewCell"

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    
    func configure(food: Request) {
        FoodImage.sd_setImage(with: URL(string: food.imageURL))
        FoodName.text = food.name
    }
    
}
