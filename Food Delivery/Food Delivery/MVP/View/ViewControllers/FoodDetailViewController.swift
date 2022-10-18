//
//  FoodDetailViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 14.10.2022.
//

import UIKit
import SDWebImage

class FoodDetailViewController: UIViewController {

    var name: String = ""
    var imageURL: String = ""
    var price: Double = 0.0
    var carbs: Int = 0
    var calories: Int = 0
    
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodPrice: UILabel!
    @IBOutlet weak var FoodCarbs: UILabel!
    @IBOutlet weak var FoodCalories: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FoodImage.sd_setImage(with: URL(string: imageURL))
        FoodName.text = name
        FoodPrice.text = "цена: \(price) р"
        FoodCarbs.text = "углеводы: \(carbs)"
        FoodCalories.text = "калории: \(calories)"
    }
    
}
