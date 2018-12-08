//
//  AppsConstants.swift
//  Hourglass
//
//  Created by 김문옥 on 06/12/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit

struct AppsConstants {
    
    static let appMainColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)

    enum night: Int {
        case textColor = 0xeaeaea
        case backGroundColor = 0x1b1c1e
        case detailTextColor = 0x6b6b6b
        case backViewColor = 0x161718
        case iconBackgroundColor = 0x2b2b2b
        case separatorColor = 0x38383c
    }
    
    enum normal: Int {
        case textColor = 0x222222
        case backGroundColor = 0xfafafa
        case detailTextColor = 0x8b8b8b
        case backViewColor = 0xefeff4
        case iconBackgroundColor = 0xe7e7ec
        case separatorColor = 0xc8c8cc
    }
}
