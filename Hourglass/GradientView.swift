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
    
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var middleColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    enum Directions: Int {
        case Horizontal
        case Vertical
        case Diagonal_1 // 대각선1
        case Diagonal_2 // 대각선2
    }
    
    var direction: Directions = .Horizontal {
        didSet {
            updateView()
        }
    }
    
    // IB: use the adapter
    @IBInspectable var directionAdapter: Int {
        get {
            return self.direction.rawValue
        }
        set( directionIndex ) {
            self.direction = Directions(rawValue: directionIndex) ?? .Horizontal
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    var fromColors: [CGColor]?
    
    var toColors: [CGColor]? { // 원할 때 이 프로퍼티의 값을 변경해주면 그라데이션 색상 전환 애니메이션 효과를 얻을 수 있다.
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        
//        if middleColor == nil {
//            layer.locations = [0.0, 1.0]
//            layer.colors = [startColor, endColor].map{$0.cgColor}
//        } else {
//            layer.locations = [0.0, 0.5, 1.0]
//            layer.colors = [startColor, middleColor!, endColor].map{$0.cgColor}
//        }
        
        layer.locations = [0.0, 0.5, 1.0]
        layer.colors = [startColor, middleColor, endColor].map{$0.cgColor}
        
        switch (self.direction) {
        case .Horizontal:
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
            break
        case .Vertical:
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
            break
        case .Diagonal_1:
//            gradient.startPoint = CGPoint(x: -0.19444444444, y: 0.109375)
//            gradient.endPoint = CGPoint (x: 1.19444444444, y: 0.890625)
            layer.startPoint = CGPoint(x: 0.25, y: 0)
            layer.endPoint = CGPoint (x: 0.75, y: 1)
//            gradient.startPoint = CGPoint(x: 0, y: 0.21875)
//            gradient.endPoint = CGPoint (x: 1, y: 0.78125)
            break
        case .Diagonal_2:
            layer.startPoint = CGPoint(x: 0.75, y: 0)
            layer.endPoint = CGPoint (x: 0.25, y: 1)
            break
        }
        
        animateLayer(gradient: layer)
    }
    
    func animateLayer(gradient: CAGradientLayer) {
        
        fromColors = fromColors ?? [startColor, middleColor, endColor].map{$0.cgColor}
//        var toColors = [ UIColor.blue.cgColor, UIColor.blue.cgColor, UIColor.blue.cgColor]
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        if self.viewWithTag(1) == nil { // WorkResultVC
            animation.duration = 0.275
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        } else { // WorkingVC
            animation.duration = 2.5
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        }
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.delegate = self as? CAAnimationDelegate
        
        gradient.add(animation, forKey:"animateGradient")
        
        fromColors = toColors
    }
}
