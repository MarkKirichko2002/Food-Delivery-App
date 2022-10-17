//
//  TabTableViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 17.10.2022.
//

import UIKit

let TabTableViewCellID = "FoodTableViewCell"

import UIKit

class FoodTableViewCell: UITableViewCell {

    static let identifier = "FoodTableViewCell"
    
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodPrice: UILabel!
    
}
