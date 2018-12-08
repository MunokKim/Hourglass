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
            contentView.backgroundColor = isSelected ? AppsConstants.appMainColor : UIColor.clear
            contentView.layer.cornerRadius = isSelected ? contentView.layer.frame.width / 2.66 : 0
            contentView.layer.masksToBounds = true
        }
    }
}
