//
//  PopoverCollectionViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 30/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight
import SwiftIcons

extension SendValueToViewControllerDelegate {
    
    func sendIconNumber(value: Int32) {}
}

private let reuseIdentifier = "popoverIconCell"

class PopoverCollectionViewController: UICollectionViewController {
    
    var delegation: SendValueToViewControllerDelegate?
    var iconNumber: Int32?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), night: UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1))
        collectionView.mixedBackgroundColor = MixedColor(normal: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), night: UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1))
        self.popoverPresentationController?.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x121315)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let value = iconNumber {
            
            delegation?.sendIconNumber(value: value)
        }
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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return 1
        } else if section == 1 {
            return IcofontType.count
        }
        return Int()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? IconCell else {
            print("errer! : \(description)")
            return UICollectionViewCell()
        }
        
        // Configure the cell
        
        var mixedTextColor: UIColor = UIColor.black
        var mixedBackgroundColor: UIColor = UIColor.white
        
        if NightNight.theme == .night {
            mixedTextColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 27/255, green: 28/255, blue: 30/255, alpha: 1)
        } else if NightNight.theme == .normal {
            mixedTextColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            mixedBackgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
        
        if indexPath.section == 0 {
            cell.iconImageView.setIcon(icon: .icofont(.hourGlass), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
        } else if indexPath.section == 1 {
            if let iconCase = IcofontType(rawValue: indexPath.row) {
                cell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
                cell.iconImageView.image!.withAlignmentRectInsets(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            }
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
        
        if indexPath.section == 0 {
            selecedCell.iconImageView.setIcon(icon: .icofont(.hourGlass), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
            iconNumber = 1081 // hourGlass
        } else if indexPath.section == 1 {
            if let iconCase = IcofontType(rawValue: indexPath.row) {
                selecedCell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
                iconNumber = Int32(indexPath.row)
            }
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
        
        if indexPath.section == 0 {
            selecedCell.iconImageView.setIcon(icon: .icofont(.hourGlass), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
        } else if indexPath.section == 1 {
            if let iconCase = IcofontType(rawValue: indexPath.row) {
                selecedCell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: mixedBackgroundColor, size: CGSize(width: 40, height: 40))
            }
        }
    }
}
