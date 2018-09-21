//
//  File.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 21..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit

extension UIDevice {
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 && UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }
    
    public var isiPhonePlus: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 736 && UIScreen.main.bounds.size.width == 414) {
            return true
        }
        return false
    }
    
    public var isiPhoneX: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 812 && UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
    
    public var isiPhoneXMax: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 896 && UIScreen.main.bounds.size.width == 414) {
            return true
        }
        return false
    }
    
    public var isiPad: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 1024 && UIScreen.main.bounds.size.width == 768) {
            return true
        }
        return false
    }
    public var isiPadPro12: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 1366 && UIScreen.main.bounds.size.width == 1366) {
            return true
        }
        return false
    }
}
