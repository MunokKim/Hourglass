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
        self.popoverPresentationController?.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: 0x121315)
        
        // 초기값 아이템 선택
        if let iconNumber = iconNumber {
            if iconNumber == 1081 {
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
            } else {
                self.collectionView.selectItem(at: IndexPath(item: Int(iconNumber), section: 1), animated: true, scrollPosition: .centeredVertically)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 초기값 아이템 선택
        if let iconNumber = iconNumber {
            if iconNumber == 1081 {
                self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
            } else {
                self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: Int(iconNumber), section: 1))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if iconNumber == nil {
            delegation?.sendIconNumber(value: 1081)
        } else {
            delegation?.sendIconNumber(value: iconNumber!)
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
        
        let mixedTextColor = NightNight.theme == .night ? UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1) : UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        
        if indexPath.section == 0 {
            cell.iconImageView.setIcon(icon: .icofont(.hourGlass), textColor: mixedTextColor, backgroundColor: .clear, size: nil)
        } else if indexPath.section == 1 {
            if let iconCase = IcofontType(rawValue: indexPath.item) {
                cell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: mixedTextColor, backgroundColor: .clear, size: nil)
                //                cell.iconImageView.image!.withAlignmentRectInsets(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
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
        
        if indexPath.section == 0 {
            iconNumber = nil
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init(rawValue: 0))
        } else if indexPath.section == 1 {
            iconNumber = Int32(indexPath.item)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init(rawValue: 0))
        }
        collectionView.cellForItem(at: indexPath)
    }
}
