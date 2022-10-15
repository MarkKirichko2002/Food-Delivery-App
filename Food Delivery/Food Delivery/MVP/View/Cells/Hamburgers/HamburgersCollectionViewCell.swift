//
//  HamburgersCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 15.10.2022.
//

import UIKit
import SDWebImage

class HamburgersCollectionViewCell: UICollectionViewCell {

    static let identifier = "HamburgersCollectionViewCell"

    @IBOutlet weak var HamburgerImage: UIImageView!
    @IBOutlet weak var HamburgerName: UILabel!
    
    func configure(hamburgers: Request) {
        HamburgerImage.sd_setImage(with: URL(string: hamburgers.imageURL))
        HamburgerName.text = hamburgers.name
    }

}
