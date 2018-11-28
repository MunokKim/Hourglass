//
//  iconCollectionViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 22/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import SwiftIcons
import NightNight

private let reuseIdentifier = "iconCell"

class iconCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), night: UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1))
        collectionView.mixedBackgroundColor = MixedColor(normal: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), night: UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1))
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return IcofontType.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? IconCell else {
            print("errer! : \(description)")
            return UICollectionViewCell()
        }
    
        // Configure the cell
        
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.layer.frame.width / 2.66
        cell.iconImageView.clipsToBounds = true
        
        var mixedTextColor: UIColor = UIColor.black
        var mixedBackgroundColor: UIColor = UIColor.white
        
        if NightNight.theme == .night {
            mixedTextColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1)
        } else if NightNight.theme == .normal {
            mixedTextColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
        
        if let iconCase = IcofontType(rawValue: indexPath.row) {
            cell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
            cell.iconImageView.image!.withAlignmentRectInsets(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selecedCell = collectionView.cellForItem(at: indexPath) as? IconCell else { return }
        
        var mixedTextColor: UIColor = UIColor.black
        var mixedBackgroundColor: UIColor = UIColor.white
        
        if NightNight.theme == .night {
            mixedTextColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            mixedBackgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        } else if NightNight.theme == .normal {
            mixedTextColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            mixedBackgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        }
        
        if let iconCase = IcofontType(rawValue: indexPath.row) {
            selecedCell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let selecedCell = collectionView.cellForItem(at: indexPath) as? IconCell else { return }
        
        var mixedTextColor: UIColor = UIColor.black
        var mixedBackgroundColor: UIColor = UIColor.white
        
        if NightNight.theme == .night {
            mixedTextColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1)
        } else if NightNight.theme == .normal {
            mixedTextColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
        
        if let iconCase = IcofontType(rawValue: indexPath.row) {
            selecedCell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
        }
    }
}


