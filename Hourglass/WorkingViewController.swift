//
//  WorkingViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import QuartzCore

class WorkingViewController: UIViewController {
    
    var selectedIndex: Int?
    
    var isTimerRunning: Bool = true
    
    let playImage = UIImage(named: "play.png")
    let pauseImage = UIImage(named: "pause.png")

    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var workNameLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var workStartTimeLabel: UILabel!
    @IBOutlet var estimatedCompletionTimeLabel: UILabel!
    
    @IBOutlet var cancelButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var completeButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func stopTimer(_ sender: Any) {
        
        animationForStopOrResume()
    }
    
    func animationForStopOrResume() {
        
        if isTimerRunning {
            
            // 남은 시간 타이머 중단
            // 예상 완료 타이머 재개
            
            stopButton.setImage(playImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButton.isHidden = false
            completeButton.isHidden = false
            
            cancelButtonCenterXConstraint.constant = 105
            completeButtonCenterXConstraint.constant = 105
            
            UIView.animate(withDuration: 0.25, animations: ({
                
                self.cancelButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.completeButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
            })
            
            isTimerRunning = false
            
        } else {
            
            // 남은 시간 타이머 재개
            // 예상 완료 타이머 중단
            
            stopButton.setImage(pauseImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButtonCenterXConstraint.constant = 0
            completeButtonCenterXConstraint.constant = 0
            
            UIView.animate(withDuration: 0.25, animations: ({
                
                self.cancelButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                self.completeButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
                
            })
            
            isTimerRunning = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title 비활성화 하기
//        navigationItem.largeTitleDisplayMode = .never
        
        // navigationBar 색상바꾸는 법.
//        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        print("WorkingViewController!!!")
//        self.view.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
//        addGradientToView()
        
        workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
        workIconImageView.clipsToBounds = true
        
        stopButton.layer.borderColor = UIColor.white.cgColor
        stopButton.layer.borderWidth = 5
        stopButton.layer.cornerRadius = stopButton.layer.frame.width / 2.66
        stopButton.clipsToBounds = true
        
        cancelButton.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0)
        cancelButton.layer.cornerRadius = cancelButton.layer.frame.width / 2.66
        cancelButton.clipsToBounds = true
        cancelButton.isHidden = true
        
        completeButton.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0)
        completeButton.layer.cornerRadius = completeButton.layer.frame.width / 2.66
        completeButton.clipsToBounds = true
        completeButton.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGradientToView() {
        
//        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0.3, y: 0)
        gradient.endPoint = CGPoint(x: 0.7, y: 1)
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        
        view.layer.addSublayer(gradient)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
