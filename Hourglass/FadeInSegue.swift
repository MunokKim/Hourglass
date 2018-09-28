//
//  FadeInSegue.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 25..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit

class FadeInSegue: UIStoryboardSegue {
    
    override func perform() {
        
        guard let destinationView = self.destination.view else {
            // Fallback to no fading
            self.source.present(self.destination, animated: false, completion: nil)
            return
        }
        
//        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
//
//        destinationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        destinationView.alpha = 0
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destinationView, aboveSubview: self.source.view)
        
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            
            destinationView.alpha = 1
        }, completion: { _ in
            
            self.source.present(self.destination, animated: false, completion: nil)
        })
    }
}
