//
//  AnimationClass.swift
//  Food Delivery
//
//  Created by Марк Киричко on 14.10.2022.
//

import Foundation
import UIKit

class AnimationClass {
        
    func springLabel(label: UILabel) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 300
        animation.mass = 1
        animation.duration = 0.5
        animation.beginTime = CACurrentMediaTime() + 0
        label.layer.add(animation, forKey: nil)
    }

    func springImage(image: UIImageView) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 300
        animation.mass = 1
        animation.duration = 0.5
        animation.beginTime = CACurrentMediaTime() + 0
        image.layer.add(animation, forKey: nil)
    }
    
}

