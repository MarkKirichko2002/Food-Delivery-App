//
//  SplashScreenViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 14.10.2022.
//

import Foundation
import UIKit

class SplashScreenController: UIViewController {
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Text: UILabel!
    
    var animation = AnimationClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Image.layer.cornerRadius = Image.layer.frame.width / 2
        Image.layer.borderWidth = 5
        animation.springImage(image: Image)
        SplashScreen()
    }
   
    func SplashScreen() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.Text.text = "Доставка Еды"
            self.animation.springLabel(label: self.Text)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController {
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .currentContext
                self.present(controller, animated: false, completion: nil)
            }
        }
    }
}
