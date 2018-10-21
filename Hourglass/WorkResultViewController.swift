//
//  workResultViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 21/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit

class WorkResultViewController: UIViewController {
    
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var workIconImageView: UIImageView! {
        didSet {
            workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
            workIconImageView.clipsToBounds = true
            workIconImageView.layer.shadowColor = UIColor.lightGray.cgColor
            workIconImageView.layer.shadowRadius = 2.0
            workIconImageView.layer.shadowOpacity = 0.5
            workIconImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            workIconImageView.layer.masksToBounds = false
        }
    }
    @IBOutlet var workNameLabel: UILabel!
    @IBOutlet var workGoalLabel: UILabel!
    @IBOutlet var elapsedTimeLabel: UILabel!
    @IBOutlet var workStartLabel: UILabel!
    @IBOutlet var estimatedCompletionLabel: UILabel!
    @IBOutlet var actualCompletionLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var remainingTextLabel: UILabel!
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            for button in buttons {
                button.layer.shadowColor = UIColor.lightGray.cgColor
                button.layer.shadowRadius = 2.0
                button.layer.shadowOpacity = 0.5
                button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                button.layer.masksToBounds = false
                button.layer.cornerRadius = button.layer.frame.width / 2.66
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    @IBOutlet var labels: [UILabel]! {
        didSet {
            for label in labels {
                label.font = label.font.withSize(label.font.pointSize.sizeByDeviceResolution)
                
                label.layer.shadowColor = UIColor.lightGray.cgColor
                label.layer.shadowRadius = 2.0
                label.layer.shadowOpacity = 0.5
                label.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                label.layer.masksToBounds = false
            }
        }
    }
    @IBAction func closeView(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var currentWork: WorkInfo?
    var workResultInfo: TimeMeasurementInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let toColors: [CGColor]?
        var goalString: String?
        let remainingText: String?
        let remainingTime: String?
        
        if workResultInfo?.goalSuccessOrFailWhether ?? true {
            
            toColors = [UIColor(red:0.99, green:0.74, blue:0.24, alpha:1.00),
                        UIColor(red:0.57, green:0.75, blue:0.51, alpha:1.00),
                        UIColor(red:0.17, green:0.75, blue:0.76, alpha:1.00)].map{$0.cgColor}
            goalString = "목표 달성"
            
            if let achievement = workResultInfo?.successiveGoalAchievement, achievement >= Int16(1) {
                goalString = "\(achievement)회 연속 " + goalString!
            }
            
            remainingText = "남은 시간"
            remainingTime = workResultInfo?.remainingTime.secondsToString
        } else {
            toColors = [UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),
                        UIColor(red:0.34, green:0.12, blue:0.10, alpha:1.00),
                        UIColor(red:0.68, green:0.24, blue:0.20, alpha:1.00)].map{$0.cgColor}
            goalString = "목표 실패"
            remainingText = "지난 시간"
            remainingTime = "+ " + abs((workResultInfo?.remainingTime) ?? 0).secondsToString
        }
        
        gradientView.toColors = toColors
        
        workNameLabel.text = currentWork?.workName
        workGoalLabel.text = goalString
        elapsedTimeLabel.text = workResultInfo?.elapsedTime.secondsToString
        workStartLabel.text = workResultInfo?.workStart?.stringFromDate
        estimatedCompletionLabel.text = workResultInfo?.workStart?.addingTimeInterval(TimeInterval(workResultInfo?.estimatedWorkTime ?? 0)).stringFromDate
        actualCompletionLabel.text = workResultInfo?.actualCompletion?.stringFromDate
        remainingTextLabel.text = remainingText
        remainingTimeLabel.text = remainingTime
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animateText), userInfo: nil, repeats: true)
    }
    
    @objc func animateText() {
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseIn, animations: {
            self.workGoalLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            self.workGoalLabel.alpha = 1.0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
