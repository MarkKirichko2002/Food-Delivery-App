//
//  FoodTableViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 16.10.2022.
//

import UIKit
import SDWebImage

class FoodTableViewCell: UITableViewCell {

    static let identifier = "FoodTableViewCell"
    
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodPrice: UILabel!
    
}
