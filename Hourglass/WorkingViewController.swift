//
//  WorkingViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class WorkingViewController: UIViewController {
    
    var elapsedTime: Int32?
    var workStart: NSDate?
    var estimatedWorkTime: Int32?
    var remainingTime: Int32?
    var selectedIndex: Int?
    var estimatedCompletion: NSDate?
    var firstEstimatedCompletion: NSDate?
    var resumeTimer: Timer? = Timer()
    var pauseTimer: Timer? = Timer()
    var momentForEnterBackground: NSDate?
    var momentForEnterForeground: NSDate?
    
    let context = AppDelegate.viewContext
    
    var fetchResult = WorkInfo()
    var workResultInfo: TimeMeasurementInfo?
    
    var isStopwatchRunning: Bool = false
    
    let playImage = UIImage(named: "play.png")
    let pauseImage = UIImage(named: "pause.png")
    
    @IBOutlet var zoomOutButton: UIButton!
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
    @IBOutlet var remainingTextLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var workStartTextLabel: UILabel!
    @IBOutlet var workStartTimeLabel: UILabel!
    @IBOutlet var estimatedCompletionTextLabel: UILabel!
    @IBOutlet var estimatedCompletionTimeLabel: UILabel!
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
    
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var completeGradientView: GradientView! {
        didSet {
            completeGradientView.isHidden = true
        }
    }
    
    @IBOutlet var cancelButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var completeButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func zoomOutView(_ sender: Any) {
        
        
    }
    
    @IBAction func workCancel(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "작업을 종료하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let endAction = UIAlertAction(title: "종료", style: UIAlertAction.Style.destructive, handler: { _ in
            self.resumeTimer?.invalidate()
            self.resumeTimer = nil
            self.pauseTimer?.invalidate()
            self.pauseTimer = nil
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        
        cancelAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(endAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func workResumeOrPause(_ sender: Any) {
        
        if isStopwatchRunning {

            pause()
            
            animateBy()
            
            isStopwatchRunning = false
            
        } else {
            
            resume()
            
            animateBy()
            
            isStopwatchRunning = true
        }
    }
    
    func pause() {
        
        // 남은 시간 타이머 중단
        resumeTimer?.invalidate()
        
        // 예상 완료 타이머 재개
        pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalOfPause), userInfo: nil, repeats: true)
    }
    
    func resume() {
        
        // 예상 완료 타이머 중단
        pauseTimer?.invalidate()
        
        // 남은 시간 타이머 재개
        resumeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalOfResume), userInfo: nil, repeats: true)
    }
    
    @IBAction func workComplete(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "작업을 완료하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let completionAction = UIAlertAction(title: "완료", style: UIAlertAction.Style.default, handler: { _ in
            self.resumeTimer?.invalidate()
            self.resumeTimer = nil
            self.pauseTimer?.invalidate()
            self.pauseTimer = nil
            
            self.saveTimeMeasurementInfo()
            
            self.performSegue(withIdentifier: "WorkResultSegue", sender: nil)
        })
        
        cancelAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
        completionAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(completionAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func renewalOfPause() {
        
        if remainingTime! >= Int32(0) {
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(1)
        }
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
        view.layoutIfNeeded()
        
        if remainingTime! >= Int32(0) {
            
            UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseIn, animations: {
                self.estimatedCompletionTextLabel.alpha = 0.0
                self.estimatedCompletionTimeLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { _ in
                self.estimatedCompletionTextLabel.alpha = 1.0
                self.estimatedCompletionTimeLabel.alpha = 1.0
            }
        }
    }
    
    @objc func renewalOfResume() {
        
        // 소요 시간 누적
        elapsedTime = (elapsedTime ?? 0) + 1
        
        // 남은 시간 계산
        remainingTime = (estimatedWorkTime)! - (elapsedTime)!
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        if (remainingTime! >= Int32(0)) {
            remainingTimeLabel.text = remainingTime?.secondsToStopwatch
        } else {
            remainingTimeLabel.text = "+\(abs(remainingTime!).secondsToStopwatch)"
            remainingTextLabel.text = "지난 시간"
        }
    }
    
    func animateBy() {
        
        if isStopwatchRunning {
            
            stopButton.setImage(playImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButton.isHidden = false
            completeButton.isHidden = false
            
            cancelButtonCenterXConstraint.constant = 105
            completeButtonCenterXConstraint.constant = 105
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: ({
                
                // 'between the clouds' 그라디언트
                self.gradientView.toColors = [UIColor(red:0.46, green:0.78, blue:0.66, alpha:1.00),
                                              UIColor(red:0.33, green:0.50, blue:0.46, alpha:1.00),
                                              UIColor(red:0.22, green:0.23, blue:0.27, alpha:1.00)].map{$0.cgColor}

                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
            })
            
        } else {
            
            stopButton.setImage(pauseImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButtonCenterXConstraint.constant = 0
            completeButtonCenterXConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: ({
                
                // 'sunrise' 그라디언트
                self.gradientView.toColors = [UIColor(red:0.99, green:0.34, blue:0.23, alpha:1.00),
                                              UIColor(red:0.96, green:0.47, blue:0.20, alpha:1.00),
                                              UIColor(red:0.94, green:0.60, blue:0.18, alpha:1.00)].map{$0.cgColor}
                
                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
                
            })
        }
    }
    
    func saveTimeMeasurementInfo() {
        
        // Core Data 영구 저장소에 TimeMeasurementInfo 데이터 추가하기
        let timeMeasurementInfo = TimeMeasurementInfo(context: context)
        
        timeMeasurementInfo.workStart = workStart
        let now = NSDate()
        timeMeasurementInfo.actualCompletion = now
        timeMeasurementInfo.goalSuccessOrFailWhether = {
            return (firstEstimatedCompletion?.timeIntervalSinceReferenceDate)! >= now.timeIntervalSinceReferenceDate
        }() // 목표 달성/실패 여부 -> 작업을 시작했을때의 최초예상완료와 현재시간을 비교한다.
        timeMeasurementInfo.successiveGoalAchievement = {
            return timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0
        }() // 연속목표달성
        timeMeasurementInfo.estimatedWorkTime = fetchResult.estimatedWorkTime // 예상작업시간
        timeMeasurementInfo.elapsedTime = (elapsedTime)!
        timeMeasurementInfo.remainingTime = (remainingTime)!
        timeMeasurementInfo.work = fetchResult // 어떤 작업에 해당하는 시간측정정보인지
        
        fetchResult.currentSuccessiveAchievementWhether = {
            return timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0
        }() // 현재연속달성여부
        fetchResult.successiveAchievementHighestRecord = {
            return fetchResult.currentSuccessiveAchievementWhether >= fetchResult.successiveAchievementHighestRecord ? fetchResult.currentSuccessiveAchievementWhether : fetchResult.successiveAchievementHighestRecord
        }() // 연속달성최고기록
        
        do {
            try context.save()
            
            print("Context Save Success!")
            print("timeMeasurementInfo >>>>>>>>>> \(timeMeasurementInfo)")
            print("workInfo >>>>>>>>>> \(fetchResult)")
            
            workResultInfo = timeMeasurementInfo
            
        } catch let nserror as NSError {
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func showResultView(timeMeasurementInfo: TimeMeasurementInfo) {
        
        completeGradientView.isHidden = false
        self.view.layoutIfNeeded()
        
        let toColors: [CGColor]?
        
        if timeMeasurementInfo.goalSuccessOrFailWhether {
            toColors = [UIColor(red:0.99, green:0.74, blue:0.24, alpha:1.00),
                        UIColor(red:0.57, green:0.75, blue:0.51, alpha:1.00),
                        UIColor(red:0.17, green:0.75, blue:0.76, alpha:1.00)].map{$0.cgColor}
            
        } else {
            toColors = [UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),
                        UIColor(red:0.34, green:0.12, blue:0.10, alpha:1.00),
                        UIColor(red:0.68, green:0.24, blue:0.20, alpha:1.00)].map{$0.cgColor}
        }
        
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveLinear, animations: ({
            
            // 'rainbow blue' 그라디언트
            self.completeGradientView.toColors = toColors
            
            self.view.layoutIfNeeded()
        }), completion: { _ in
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print("WorkingViewController!!!")
        
        stopButton.layer.borderWidth = 5
        cancelButton.layer.borderWidth = 5
        completeButton.layer.borderWidth = 5
        
        contextFetchToSelectedIndex()
        
        workResumeOrPause((Any).self)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name:UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func didEnterBackground() {
        
        resumeTimer?.invalidate()
        resumeTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
        
        momentForEnterBackground = NSDate()
    }
    
    @objc func willEnterForeground() {
        
        momentForEnterForeground = NSDate()
        
        let lostTime: TimeInterval = momentForEnterForeground!.timeIntervalSinceReferenceDate - momentForEnterBackground!.timeIntervalSinceReferenceDate
        
        if isStopwatchRunning {
            
            elapsedTime = elapsedTime! + Int32(lostTime)
            resume()
        } else {
            
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(lostTime)
            pause()
        }
    }
    
    func contextFetchToSelectedIndex() {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        request.predicate = NSPredicate(format: "workID == \(selectedIndex!)")
        
        do {
            let resultArray = try context.fetch(request)
            
            fetchResult = resultArray[0]
            print(fetchResult)
            
            workStart = NSDate()
            estimatedWorkTime = fetchResult.estimatedWorkTime
            estimatedCompletion = workStart!.addingTimeInterval(TimeInterval((estimatedWorkTime)!))
            firstEstimatedCompletion = estimatedCompletion
            
            //            iconImagePath = fetchResult.iconImagePath
            workNameLabel.text = fetchResult.workName!
            workStartTimeLabel.text = workStart?.stringFromDate
            remainingTimeLabel.text = estimatedWorkTime?.secondsToStopwatch
            estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "WorkResultSegue" {
            
            if let vc = segue.destination as? workResultViewController {
                
                print("workResult is : \(self.workResultInfo)")
                vc.currentWork = self.fetchResult
                vc.workResultInfo = self.workResultInfo
            }
        }
     }
    
}

extension NSDate {
    
    var stringFromDate: String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm:ss"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        return formatter.string(from: self as Date)
    }
    
    var dateToInt32: Int32 {
        return Int32(self.timeIntervalSince1970)
    }
}

extension CGFloat {
    
    var sizeByDeviceResolution: CGFloat {
        return (self / 375) * (UIScreen.main.bounds.width)
    }
}
