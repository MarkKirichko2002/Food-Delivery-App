//
//  TabBarCollectionViewCell.swift
//  Food Delivery
//
//  Created by Марк Киричко on 17.10.2022.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tabNameLabel: UILabel!
    
    static let identifier = "TabBarCollectionViewCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        /*
         *  To avoid compression of labels, the below code must be present.
         */
        
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

