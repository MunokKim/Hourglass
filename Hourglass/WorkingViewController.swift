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
    @IBOutlet var remainingTextLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var workStartTextLabel: UILabel!
    @IBOutlet var workStartTimeLabel: UILabel!
    @IBOutlet var estimatedCompletionTextLabel: UILabel!
    @IBOutlet var estimatedCompletionTimeLabel: UILabel!
    
    @IBOutlet var cancelButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var completeButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func zoomOutView(_ sender: Any) {
        
        // 임시로 그냥 창 닫기로 해놓음
        dismiss(animated: true)
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        
        timerOperationBy(state: isTimerRunning)
        
        animateBy(state: isTimerRunning)
    }
    
    func timerOperationBy(state: Bool) {
        
        if state {
            
            // 남은 시간 타이머 중단
            // 예상 완료 타이머 재개
        } else {
            
            // 남은 시간 타이머 재개
            // 예상 완료 타이머 중단
        }
    }
    
    func animateBy(state: Bool) {
        
        if state {
            
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
        
        workNameLabel.layer.shadowColor = UIColor.white.cgColor
        workNameLabel.layer.shadowRadius = 2.0
        workNameLabel.layer.shadowOpacity = 0.75
        workNameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        workNameLabel.layer.masksToBounds = false
        
        remainingTextLabel.layer.shadowColor = UIColor.white.cgColor
        remainingTextLabel.layer.shadowRadius = 1.5
        remainingTextLabel.layer.shadowOpacity = 0.5
        remainingTextLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        remainingTextLabel.layer.masksToBounds = false
        
        remainingTimeLabel.layer.shadowColor = UIColor.white.cgColor
        remainingTimeLabel.layer.shadowRadius = 2.0
        remainingTimeLabel.layer.shadowOpacity = 1.0
        remainingTimeLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        remainingTimeLabel.layer.masksToBounds = false
        
        workStartTimeLabel.layer.shadowColor = UIColor.white.cgColor
        workStartTimeLabel.layer.shadowRadius = 1.5
        workStartTimeLabel.layer.shadowOpacity = 0.5
        workStartTimeLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        workStartTimeLabel.layer.masksToBounds = false
        
        estimatedCompletionTimeLabel.layer.shadowColor = UIColor.white.cgColor
        estimatedCompletionTimeLabel.layer.shadowRadius = 1.5
        estimatedCompletionTimeLabel.layer.shadowOpacity = 0.5
        estimatedCompletionTimeLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        estimatedCompletionTimeLabel.layer.masksToBounds = false
        
        workStartTextLabel.layer.shadowColor = UIColor.white.cgColor
        workStartTextLabel.layer.shadowRadius = 1.5
        workStartTextLabel.layer.shadowOpacity = 0.5
        workStartTextLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        workStartTextLabel.layer.masksToBounds = false
        
        estimatedCompletionTextLabel.layer.shadowColor = UIColor.white.cgColor
        estimatedCompletionTextLabel.layer.shadowRadius = 1.5
        estimatedCompletionTextLabel.layer.shadowOpacity = 0.5
        estimatedCompletionTextLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        estimatedCompletionTextLabel.layer.masksToBounds = false
        
        stopButton.layer.shadowColor = UIColor.white.cgColor
        stopButton.layer.shadowRadius = 4.0
        stopButton.layer.shadowOpacity = 1.0
        stopButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        stopButton.layer.masksToBounds = false
        
        cancelButton.layer.shadowColor = UIColor.white.cgColor
        cancelButton.layer.shadowRadius = 4.0
        cancelButton.layer.shadowOpacity = 1.0
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cancelButton.layer.masksToBounds = false
        
        completeButton.layer.shadowColor = UIColor.white.cgColor
        completeButton.layer.shadowRadius = 4.0
        completeButton.layer.shadowOpacity = 1.0
        completeButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        completeButton.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
