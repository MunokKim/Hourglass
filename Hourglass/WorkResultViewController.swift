//
//  workResultViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 21/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import MarqueeLabel
import CoreData
import SwiftIcons

class WorkResultViewController: UIViewController {
    
    @IBOutlet var subviews: [UIView]! {
        didSet {
            Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(layoutShadows), userInfo: nil, repeats: false)
        }
    }
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var workNameLabel: MarqueeLabel! {
        didSet {
            Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(layoutShadows), userInfo: nil, repeats: false)
            
            workNameLabel.font = UIFont(name: "GodoB", size: CGFloat(32).sizeByDeviceResolution)
        }
    }
    @IBOutlet var workGoalLabel: UILabel!
    @IBOutlet var elapsedTimeLabel: UILabel!
    @IBOutlet var workStartLabel: UILabel!
    @IBOutlet var estimatedCompletionLabel: UILabel!
    @IBOutlet var actualCompletionLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var remainingTextLabel: UILabel!
    @IBOutlet var labels: [UILabel]! {
        didSet {
            for label in labels {
                label.font = label.font.withSize(label.font.pointSize.sizeByDeviceResolution)
            }
        }
    }
    @IBOutlet var laurels: [UIImageView]! {
        didSet {
            for laurel in laurels {
                laurel.isHidden = true
            }
        }
    }
    @IBOutlet var gestureView: UIView!
    
    @IBAction func closeView(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchAndRenewalNoti"), object: nil)
        self.presentingViewController?.modalTransitionStyle = .coverVertical
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 초기 터치 위치
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let touchPoint = sender.location (in : self.view? .window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect (x : 0, y : touchPoint.y - initialTouchPoint.y, width : self.view.frame.size.width, height : self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchAndRenewalNoti"), object: nil)
                self.presentingViewController?.modalTransitionStyle = .coverVertical
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration : 0.3, animations: {
                    self.view.frame = CGRect (x : 0, y : 0, width : self.view.frame.size.width, height : self.view.frame.size.height)
                })
            }
        }
    }
    
    let context = AppDelegate.viewContext
    var currentWork: WorkInfo?
    var workResultInfo: TimeMeasurementInfo?
    var panGesture = UIPanGestureRecognizer()
    var gradientTimer: Timer? = Timer()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        gradientTimer?.invalidate()
        gradientTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 손가락 내려서 창 닫기 제스처
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:)))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(panGesture)
        
        var toColors: [CGColor]?
        var goalString: String? 
        let remainingText: String?
        let remainingTime: String?
        let situation: Bool?
        
        guard let workResultInfo = workResultInfo else { return }
        
        // 목표 달성
        if workResultInfo.goalSuccessOrFailWhether {
            // 'Atlas' 그라디언트
            toColors = [UIColor(red:0/255, green:202/255, blue:96/255, alpha:1.00),
                        UIColor(red:2/255, green:159/255, blue:163/255, alpha:1.00),
                        UIColor(red:5/255, green:117/255, blue:230/255, alpha:1.00)].map{$0.cgColor}
            
            gradientView.toColors = toColors
            
            // 반복적인 배경 그라디언트 변경
            var flag = 0
            gradientTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
                print("3 Seconds Gradient Repeating.......")
                
                switch flag {
                case 0:
                    toColors = [UIColor(red:247/255, green:157/255, blue:0/255, alpha:1.00),
                                UIColor(red:173/255, green:200/255, blue:70/255, alpha:1.00),
                                UIColor(red:100/255, green:243/255, blue:140/255, alpha:1.00)].map{$0.cgColor}
                    flag = 1
                case 1:
                    toColors = [UIColor(red:220/255, green:227/255, blue:91/255, alpha:1.00),
                                UIColor(red:145/255, green:204/255, blue:82/255, alpha:1.00),
                                UIColor(red:69/255, green:182/255, blue:73/255, alpha:1.00)].map{$0.cgColor}
                    flag = 2
                case 2:
                    toColors = [UIColor(red:75/255, green:192/255, blue:200/255, alpha:1.00),
                                UIColor(red:199/255, green:121/255, blue:208/255, alpha:1.00),
                                UIColor(red:211/255, green:131/255, blue:18/255, alpha:1.00)].map{$0.cgColor}
                    flag = 3
                case 3:
                    toColors = [UIColor(red:0/255, green:202/255, blue:96/255, alpha:1.00),
                                UIColor(red:2/255, green:159/255, blue:163/255, alpha:1.00),
                                UIColor(red:5/255, green:117/255, blue:230/255, alpha:1.00)].map{$0.cgColor}
                    flag = 0
                default: break
                }
                
                self.gradientView.toColors = toColors
            }
            
            goalString = "목표 달성"
            situation = true
            
            // 2회 이상 연속 목표 달성
            let achievement = workResultInfo.successiveGoalAchievement
            if achievement >= Int16(2) {

                goalString = "\(achievement)회 연속 " + goalString!

                // 월계수 이미지 표시
                for laurel in laurels {
                    laurel.isHidden = false
                }
            }
            
            remainingText = "남은 시간"
            remainingTime = workResultInfo.remainingTime.secondsToString
            
        } else { // 목표 실패
            // 'sunset' 그라디언트
            toColors = [UIColor(red:54/255, green:0/255, blue:51/255, alpha:1.00),
                        UIColor(red:113/255, green:85/255, blue:65/255, alpha:1.00),
                        UIColor(red:11/255, green:135/255, blue:147/255, alpha:1.00)].map{$0.cgColor}
            
            gradientView.toColors = toColors
            
            // 반복적인 배경 그라디언트 변경
            var flag = 0
            gradientTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
                print("3 Seconds Gradient Repeating.......")
                
                switch flag {
                case 0:
                    toColors = [UIColor(red:30/255, green:19/255, blue:12/255, alpha:1.00),
                                UIColor(red:92/255, green:75/255, blue:66/255, alpha:1.00),
                                UIColor(red:154/255, green:132/255, blue:120/255, alpha:1.00)].map{$0.cgColor}
                    flag = 1
                case 1:
                    toColors = [UIColor(red:148/255, green:142/255, blue:153/255, alpha:1.00),
                                UIColor(red:97/255, green:76/255, blue:99/255, alpha:1.00),
                                UIColor(red:46/255, green:20/255, blue:55/255, alpha:1.00)].map{$0.cgColor}
                    flag = 2
                case 2:
                    toColors = [UIColor(red:32/255, green:0/255, blue:44/255, alpha:1.00),
                                UIColor(red:117/255, green:90/255, blue:128/255, alpha:1.00),
                                UIColor(red:203/255, green:180/255, blue:212/255, alpha:1.00)].map{$0.cgColor}
                    flag = 3
                case 3:
                    toColors = [UIColor(red:54/255, green:0/255, blue:51/255, alpha:1.00),
                                UIColor(red:113/255, green:85/255, blue:65/255, alpha:1.00),
                                UIColor(red:11/255, green:135/255, blue:147/255, alpha:1.00)].map{$0.cgColor}
                    flag = 0
                default: break
                }
                
                self.gradientView.toColors = toColors
            }
            
            goalString = "목표 실패"
            situation = false
            remainingText = "지난 시간"
            remainingTime = "+ " + abs((workResultInfo.remainingTime) ?? 0).secondsToString
        }
        
        guard let currentWork = currentWork else { return }
        guard let workStart = workResultInfo.workStart, let actualCompletion = workResultInfo.actualCompletion  else { return }
        
        workNameLabel.text = currentWork.workName
        if let iconCase = IcofontType(rawValue: Int(currentWork.iconNumber)) {
            workIconImageView.setIcon(icon: .icofont(iconCase), textColor: .white, backgroundColor: .clear
                , size: nil)
        }
        workGoalLabel.text = goalString
        elapsedTimeLabel.text = workResultInfo.elapsedTime.secondsToString
        workStartLabel.text = NSDate().stringFromDate(date: workStart, formatIndex: .ahms)
        
        let ewt = workStart.addingTimeInterval(TimeInterval(workResultInfo.estimatedWorkTime))
        estimatedCompletionLabel.text = NSDate().stringFromDate(date: ewt, formatIndex: .ahms)
        actualCompletionLabel.text = NSDate().stringFromDate(date: actualCompletion, formatIndex: .ahms)
        remainingTextLabel.text = remainingText
        remainingTimeLabel.text = remainingTime
        
        // 선택된 WorkInfo객체로 불러온 TimeMeasurementInfo객체
        let timeMeasurementInfoFetchArray = contextFetchFor(ThisWork: currentWork)
        // 합계, 평균 등을 구한 뒤 WorkInfo 엔티티의 필드 업데이트
        updateWorkInfo(workInfo: currentWork, timeMeasurementInfo: timeMeasurementInfoFetchArray)
        
        // 사운드 재생
        let play = SoundEffect()
        if let situation = situation {
            if situation {
                play.playSound(situation: .success)
                play.vibrate()
            } else {
                play.playSound(situation: .fail)
                play.vibrate()
            }
        }
        
        // 레이블 깜빡임
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animateText), userInfo: nil, repeats: true)
    }
    
    func contextFetchFor(ThisWork: WorkInfo) -> [TimeMeasurementInfo] {
        
        // Core Data 영구 저장소에서 TimeMeasurementInfo 데이터 가져오기
        let request: NSFetchRequest<TimeMeasurementInfo> = TimeMeasurementInfo.fetchRequest()
        
        request.predicate = NSPredicate(format: "workID == \(ThisWork.workID)")
        
        do {
            let fetchArray = try context.fetch(request)
            
            print(fetchArray)
            
            return fetchArray
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateWorkInfo(workInfo: WorkInfo, timeMeasurementInfo: [TimeMeasurementInfo]) {
        
        guard timeMeasurementInfo.count != 0 else { return }
        
        var goalSuccess = 0
        var averageElapsed = 0
        var averageRemaining = 0
        
         // 현재 연속 달성 여부 = 목표 달성/실패 여부 ? 현재 연속 달성 여부 + 1 : 0
        let currentSuccessiveAchievementWhether = workResultInfo!.goalSuccessOrFailWhether ? workInfo.currentSuccessiveAchievementWhether + 1 : 0
        // 연속 달성 최고기록 = 현재 연속 달성 여부 >= 연속 달성 최고기록 ? 현재 연속 달성 여부 : 연속 달성 최고기록
        let successiveAchievementHighestRecord = currentSuccessiveAchievementWhether >= workInfo.successiveAchievementHighestRecord ? currentSuccessiveAchievementWhether : workInfo.successiveAchievementHighestRecord
        
        // 작업달성, 평균 남은시간, 평균 지난시간 계산하기
        for timeMeasurementInfo in timeMeasurementInfo {
            if timeMeasurementInfo.goalSuccessOrFailWhether {
                goalSuccess += 1
            }
            averageElapsed += Int(timeMeasurementInfo.elapsedTime)
            averageRemaining += Int(timeMeasurementInfo.remainingTime)
        }
        averageElapsed /= timeMeasurementInfo.count
        averageRemaining /= timeMeasurementInfo.count
        
        
        workInfo.setValue(currentSuccessiveAchievementWhether, forKey: "currentSuccessiveAchievementWhether")
        workInfo.setValue(successiveAchievementHighestRecord, forKey: "successiveAchievementHighestRecord")
        workInfo.setValue(timeMeasurementInfo.count, forKey: "totalWork")
        workInfo.setValue(goalSuccess, forKey: "goalSuccess")
        workInfo.setValue(timeMeasurementInfo.count - goalSuccess, forKey: "goalFail")
        workInfo.setValue(Float(goalSuccess) / Float(timeMeasurementInfo.count), forKey: "successRate")
        workInfo.setValue(averageElapsed, forKey: "averageElapsedTime")
        workInfo.setValue(averageRemaining, forKey: "averageRemainingTime")
//        workInfo.setValue(timeMeasurementInfo, forKey: "eachTurnsOfWork")
        
        do {
            try context.save()
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = .default
//    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
    }
    
    @objc func layoutShadows() {
        
        for subview in subviews {
            subview.layer.shadowColor = UIColor.gray.cgColor
            subview.layer.shadowRadius = 2.0
            subview.layer.shadowOpacity = 0.5
            subview.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            subview.layer.masksToBounds = false
        }
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
