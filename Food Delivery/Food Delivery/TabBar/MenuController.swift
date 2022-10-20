//
//  MenuController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 16.10.2022.
//

import UIKit

class MenuController: UITabBarController {

    var animation = AnimationClass()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setImage(UIImage(named: "pizza2"), for: .normal)
        button.layer.cornerRadius = self.button.frame.width / 2
        button.layer.borderWidth = 3
        button.clipsToBounds = true
        button.addTarget(self, action:  #selector(MenuController.animateButton), for: .touchUpInside)
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 100, width: 64, height: 64)
        button.layer.cornerRadius = 32
    }
    
    @objc func animateButton() {
        animation.springImage(button: button)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
}
