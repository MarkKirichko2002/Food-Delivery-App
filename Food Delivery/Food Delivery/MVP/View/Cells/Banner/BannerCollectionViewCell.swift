//
//  BannerCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    static let identifier = "BannerCollectionViewCell"
    
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodText: UILabel!
    
    func configure(banner: Banner) {
        FoodImage.image = UIImage(named: banner.image)
        FoodText.text = banner.text
    }
    
}
