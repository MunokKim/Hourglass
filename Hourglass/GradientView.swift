//
//  GradientView.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 25..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit

class GradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal : Bool = true {
        didSet {
            updateView ()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        
        if (self.isHorizontal) {
            
            layer.startPoint = CGPoint(x: 0, y: 0.6)
            layer.endPoint = CGPoint (x: 1, y: 0.4)
        } else {
            
            layer.startPoint = CGPoint(x: 0.4, y: 0)
            layer.endPoint = CGPoint (x: 0.6, y: 1)
        }
    }

}
