//
//  IconCell.swift
//  Hourglass
//
//  Created by 김문옥 on 28/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = iconImageView.layer.frame.width / 2.66
            iconImageView.clipsToBounds = true
        }
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) : UIColor.clear
            contentView.layer.cornerRadius = contentView.layer.frame.width / 2.66
            contentView.layer.masksToBounds = true
        }
    }
}
