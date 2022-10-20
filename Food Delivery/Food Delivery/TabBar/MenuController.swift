//
//  MenuController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 16.10.2022.
//

import UIKit

class MenuController: UITabBarController {

    var animation = AnimationClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
}
