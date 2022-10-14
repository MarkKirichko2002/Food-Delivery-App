//
//  RoundedImageView.swift
//  Food Delivery
//
//  Created by Марк Киричко on 14.10.2022.
//

import UIKit
import AVFoundation

class RoundedImageView: UIImageView {
    
    var audioPlayer = AVAudioPlayer()
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.75,
                                    delay: 0,
                                    usingSpringWithDamping: 0.50,
                                    initialSpringVelocity: 0.50,
                                    options: [.allowUserInteraction],
                                    animations: {
                                        self.bounds = self.bounds.insetBy(dx: 15, dy: 15)
                                    },
                                    completion: nil)
    }
}


