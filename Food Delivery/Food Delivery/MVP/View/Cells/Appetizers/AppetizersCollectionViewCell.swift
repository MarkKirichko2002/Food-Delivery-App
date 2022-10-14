//
//  AppetizersCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import UIKit
import SDWebImage

class AppetizersCollectionViewCell: UICollectionViewCell {

    static let identifier = "AppetizersCollectionViewCell"

    @IBOutlet weak var AppetizerImage: UIImageView!
    @IBOutlet weak var AppetizerName: UILabel!
    
    func configure(appetizers: Request) {
        AppetizerImage.sd_setImage(with: URL(string: appetizers.imageURL))
        AppetizerName.text = appetizers.name
    }
    
}
